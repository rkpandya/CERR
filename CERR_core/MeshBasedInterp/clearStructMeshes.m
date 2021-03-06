function clearStructMeshes(varargin)
%function clearStructMeshes()
%This function clears the surface meshes for passed structure uidC.
%
%APA, 06/21/07
%
% Copyright 2010, Joseph O. Deasy, on behalf of the CERR development team.
% 
% This file is part of The Computational Environment for Radiotherapy Research (CERR).
% 
% CERR development has been led by:  Aditya Apte, Divya Khullar, James Alaly, and Joseph O. Deasy.
% 
% CERR has been financially supported by the US National Institutes of Health under multiple grants.
% 
% CERR is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of CERR is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% CERR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with CERR.  If not, see <http://www.gnu.org/licenses/>.

global planC
indexS = planC{end};

if isempty(varargin)
    structNumToClear = 1:length(planC{indexS.structures});
else
    uidC = varargin{1};
    structNumToClear = getAssociatedStr(uidC);
end

%Set Matlab path to directory containing the library
currDir = cd;

if ispc
    meshDir = fileparts(which('libMeshContour.dll'));
    cd(meshDir);
    loadlibrary('libMeshContour','MeshContour.h');
elseif isunix
    meshDir = fileparts(which('libMeshContour.so'));
    cd(meshDir);
    loadlibrary('libMeshContour.so','MeshContour.h');
end
%Clear existing structure meshes
waitbarH = waitbar(0,'Clearing surface meshes for structures...');
try
    for structNum = structNumToClear
        structUID = planC{indexS.structures}(structNum).strUID;
        calllib('libMeshContour','clear',structUID)
        planC{indexS.structures}(structNum).meshRep = 0;
        planC{indexS.structures}(structNum).meshS   = [];
        waitbar(structNum/length(planC{indexS.structures}),waitbarH)
    end
end
close(waitbarH)
%switch back the current irectory
cd(currDir)
