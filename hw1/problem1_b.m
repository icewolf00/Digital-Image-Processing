filename = 'sample2.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);

filename = 'D.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
D=zeros(N,N);
D(1:Size)=pixel(1:Size);
D=permute(D, [2,1]);

%plot Histogram of I2
[count,bin] = hist(G(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of I2');
saveas(temp, 'Histogram_I2', 'jpg');

%plot Histogram of D
[count,bin] = hist(D(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of D');
saveas(temp, 'Histogram_D', 'jpg');