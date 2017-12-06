function [V,T] = readSTUFF(filename)
  % READSTUFF Read a tetrahedral mesh from Changxi Zheng's implementation of
  % isosurface stuffing.
  %
  % [V,T] = readSTUFF(filename)
  %
  % Inputs:
  %   filename  path to .stuff tet-mesh file
  % Outputs:
  %   V  #V by 3 list of vertex positions
  %   T  #T by 4 list of tet mesh indices into V
  % 
  f = fopen(filename,'rb');
  n = fread(f,1,'int');
  V = fread(f,n*3,'double');
  m = fread(f,1,'int');
  T = fread(f,m*4,'int');
  fclose(f);
  V = reshape(V,3,n)';
  T = reshape(T+1,4,m)';
end
