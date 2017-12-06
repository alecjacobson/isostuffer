function [TV,TT,TF] = isostuffer(V,F,varargin)
  % ISOSTUFFER Create a tetrahedral mesh given a watertight surface mesh
  %
  % [TV,TT] = isostuffer(V,F)
  % [TV,TT,TF] = isostuffer(V,F,varargin)
  %
  % Inputs:
  %   V  #V by 3 list of surface mesh vertex positions
  %   F  #F by 3 list of triangle mesh indices into V
  % Outputs:
  %   TV  #TV by 3 list of tet-mesh vertex positions
  %   TT  #TT by 4 list of tet-mesh indices into TV
  %   TF  #TF by 3 list of boundary surface triangle indices into TV
  %

  % default values
  flags = '';
  % Map of parameter names to variable names
  params_to_variables = containers.Map( ...
    {'Flags'}, ...
    {'flags'});
  v = 1;
  while v <= numel(varargin)
    param_name = varargin{v};
    if isKey(params_to_variables,param_name)
      assert(v+1<=numel(varargin));
      v = v+1;
      % Trick: use feval on anonymous function to use assignin to this workspace
      feval(@()assignin('caller',params_to_variables(param_name),varargin{v}));
    else
      error('Unsupported parameter: %s',varargin{v});
    end
    v=v+1;
  end

  input = tempname;
  output = tempname;
  writeOBJ(input,V,F);
  path_to_isostuffer =  ...
    [fileparts(mfilename('fullpath')) '/build/src/isostuffer'];
  command = sprintf('%s %s %s %s',path_to_isostuffer,flags,input,output);
  [status,result] = system(command);
  if status ~= 0
    warning(result);
  end
  delete(input);
  [TV,TT] = readSTUFF(output);
  delete(output);
  if nargout > 2
    TF = boundary_faces(TT);
  end
end
