function [Ur,Vr,fail] = findCOMRefObj(I,xyz,beta,dUV,thresh,meta)
%   [URef, VRef, fail] = findCOMRefObj(I,,xyz,beta,dUV,thresh,meta)
%
% given a gray shade image, I, find the intensities in a box defined by
% the center location, xyz, +/- dUV pixels using the center of mass (COM) .
% of a bright feature with intensities exceeding I=thresh.  
% The first ref obj is special and should be a bright object surrounded by 
% a large enough dark area to accommodate normal inter-frame movement 
% while still keeping the target in view.  The first point is location then
% is found to give a course correction to the guessed locations of the 
% later boxes.  If no bright pixels are found in the first ref point 
% search area, it is assumed that the aim point has changed dramatically,
% i.e. the data run is over.  In that case, fail = 1.

i = 1;
fail = 0;               % flag to indicate no bright target found
minNGood = 4;           % fail if we don't find at least this # pixels
uv = round(findUVnDOF(beta,xyz(i,:),meta.globals));
URef = [uv(1)-dUV(1,1): uv(1)+dUV(1,1)];
VRef = [uv(2)-dUV(1,2): uv(2)+dUV(1,2)];
I2 = I(VRef,URef);
[U,V] = meshgrid(URef,VRef);
good = find(I2>thresh(i));
if (length(good) < minNGood)
    Ur = []; Vr = [];
    fail = 1;
    return
end
Ur(i) = mean(U(good));
Vr(i) = mean(V(good));
% plot option
if meta.showFoundRefPoints
    figure(1+10);clf; colormap(gray)
    imagesc(URef,VRef,I2)
    hold on
    plot(Ur(i),Vr(i),'r*')
end
du = round(Ur(i) - uv(1));     % rough corrections to search guesses
dv = round(Vr(i) - uv(2));

for i = 2: size(xyz,1)
    uv = round(findUVnDOF(beta,xyz(i,:), meta.globals));
    uv = uv(:) + [du; dv];
    URef = [uv(1)-dUV(i,1): uv(1)+dUV(i,1)];
    VRef = [uv(2)-dUV(i,2): uv(2)+dUV(i,2)];
    I2 = I(VRef,URef);
    [U,V] = meshgrid(URef,VRef);
    Ur(i) = mean(U(I2>thresh(i)));
    Vr(i) = mean(V(I2>thresh(i)));
    % plot option
    if meta.showFoundRefPoints
        figure(i+10);clf; colormap(gray)
        imagesc(URef,VRef,I2)
        hold on
        plot(Ur(i),Vr(i),'r*')
    end
end
