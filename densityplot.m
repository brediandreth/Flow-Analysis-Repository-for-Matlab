function densityplot(x,y)

if size(x,1)==1 %single row vector
    cs = squareform(pdist([x' y'])); %calculate distance between all points
else %column vector
    cs = squareform(pdist([x y])); %calculate distance between all points
end

mrg = max([range(x),range(y)]);

c = sum(cs < mrg/75);

scatter(x,y,1.5,c,'.')
colormap cmap_3