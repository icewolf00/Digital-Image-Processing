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
D=G/3;

% imshow(G, [0,255]);
% imshow(D, [0,255]);
fid2=fopen('D.raw','wb');
Towrite=permute(D, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);