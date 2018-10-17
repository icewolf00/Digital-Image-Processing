filename='D.raw';
fid=fopen(filename,'rb');
if (fid==-1)
  	error('can not open iexmput image filem press CTRL-C to exit \n');
  	pause
end
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);
% imshow(G, [0,255]);

const1 = 35;
log_version = const1 * log(G+1);
imshow(log_version, [0,255]);
fid2=fopen('log.raw','wb');
Towrite=permute(log_version, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
[count,bin] = hist(log_version(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of log');
saveas(temp, 'Histogram_log', 'jpg');

const2 = 7.5;
inv_log = exp(G).^(1/const2) - 1;
imshow(inv_log, [0,255]);
fid2=fopen('inv.raw','wb');
Towrite=permute(inv_log, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
[count,bin] = hist(inv_log(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of inverse log');
saveas(temp, 'Histogram_inv', 'jpg');

const3 = 8;
gamma_power = 0.8;
% const3 = 18;
% gamma_power = 0.55;
power_version = const3 * G.^gamma_power;
imshow(power_version, [0,255]);
fid2=fopen('power.raw','wb');
Towrite=permute(power_version, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);
[count,bin] = hist(power_version(:), 0:255);
temp = stem(bin,count, 'Marker','none');
title('Histogram of power');
saveas(temp, 'Histogram_power', 'jpg');