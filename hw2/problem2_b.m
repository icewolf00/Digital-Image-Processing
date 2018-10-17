filename = 'sample3.raw';
fid=fopen(filename,'rb');
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);
% figure;
% imshow(G, [0,255]);

G_2b = zeros(N,N);

parameter_a = 40;
parameter_b = 135;
parameter_c = 20;
parameter_d = 180;
for i = 1:N
	for j = 1:N
		new_x = i + round(parameter_a*sin(2*pi*j/parameter_b));
		new_y = j + round(parameter_c*sin(2*pi*i/parameter_d));
		if new_x < 1 || new_x > N || new_y < 1 || new_y > N
			continue;
		end
		% new_x = mod(new_x, N)+1;
		% new_y = mod(new_y, N)+1;
		G_2b(i,j) = G(new_x, new_y);
	end
end
% figure;
% imshow(G_2b, [0,255]);
% imwrite(uint8(G_2b), 'G_2b.jpg');
fid2=fopen('2b.raw','wb');
Towrite=permute(G_2b, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);