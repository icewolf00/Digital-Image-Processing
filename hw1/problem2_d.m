filename='sample3.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);


filename='RG.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
RG=zeros(N,N);
RG(1:Size)=pixel(1:Size);
RG=permute(RG, [2,1]);

filename='RS.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
RS=zeros(N,N);
RS(1:Size)=pixel(1:Size);
RS=permute(RS, [2,1]);

temp1 = (G-RG).^2;
MSE1 = sum(temp1(:)) / (N*N);
PSNR1 = 10 * log10((255.^2) / MSE1);
disp("PSNR1=");
disp(PSNR1);

temp2 = (G-RS).^2;
MSE2 = sum(temp2(:)) / (N*N);
PSNR2 = 10 * log10((255.^2) / MSE2);
disp("PSNR2=");
disp(PSNR2);
