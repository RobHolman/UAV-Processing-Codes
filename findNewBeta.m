function [beta6dof,Ur,Vr,fail] = findNewBeta(Ig,beta, meta)
%   [betaNew6dof,Ur,Vr,failFlag] = findNewBeta(Ig,betaOld, meta)
%
%  computes an updated 6 dof beta for a new UAV video frame Ig, based on
%  the found locations of refPoints.  If the first ref point finds no
%  bright pixels, it is assumed that the run is over (UAV changed view
%  quickly on the way home) and failFlag is set to true.  Globals must
%  include fields lcp, knowns and knownFlags.

global globs
globs = meta.globals;

xyz = [meta.refPoints.xyz];
xyz = reshape(xyz(:),3,[])';
dUV = [meta.refPoints.dUV];
dUV = reshape(dUV(:),2,[])';
thresh = [meta.refPoints.thresh];
[Ur,Vr, fail] = findCOMRefObj(Ig,xyz,beta,dUV,thresh,meta);
if fail
    beta6dof = [];
    Ur = []; Vr = [];
    return
end

% find n-dof solution and expand to 6 dof final result
betaNew = nlinfit(xyz,[Ur(:); Vr(:)],'findUVnDOF',beta);
beta6dof(find(meta.globals.knownFlags)) = meta.globals.knowns;
beta6dof(find(~meta.globals.knownFlags)) = betaNew;

% show results in case debug is needed
figure(2); clf; colormap(gray)
imagesc(Ig)
hold on
plot(Ur,Vr,'r*')
uv = findUVnDOF(beta6dof, xyz, globs);
uv = reshape(uv,[],2);
plot(uv(:,1),uv(:,2),'ko')
