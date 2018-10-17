filename = 'H.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
H=zeros(N,N);
H(1:Size)=pixel(1:Size);
H=permute(H, [2,1]);


filename = 'L.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
L=zeros(N,N);
L(1:Size)=pixel(1:Size);
L=permute(L, [2,1]);

[count,bin] = hist(H(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of H');
saveas(temp, 'Histogram_H', 'jpg');

[count,bin] = hist(L(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of L');
saveas(temp, 'Histogram_L', 'jpg');