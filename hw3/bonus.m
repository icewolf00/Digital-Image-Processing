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

G_out = G;
mask = [0 0 1 1 1 0 0
		0 1 1 1 1 1 0
		1 1 1 1 1 1 1
		1 1 1 1 1 1 1
		1 1 1 1 1 1 1
		0 1 1 1 1 1 0
		0 0 1 1 1 0 0];
padding = zeros(N+6, N+6);
padding(4:N+3, 4:N+3) = G;
for i = 4:N+3
	for j = 4:N+3
		temp = padding(i-3:i+3, j-3:j+3);
		G_out(i-3,j-3) = max(temp(:) .* mask(:));
	end
end

% figure;
% imshow(G_out, [0,255]);
mask2 =[0 0 0 0 0 0 1 1 1 0 0 0 0 0 0
		0 0 0 0 1 1 1 1 1 1 1 0 0 0 0
		0 0 0 1 1 1 1 1 1 1 1 1 0 0 0
		0 0 1 1 1 1 1 1 1 1 1 1 1 0 0
		0 1 1 1 1 1 1 1 1 1 1 1 1 1 0
		0 1 1 1 1 1 1 1 1 1 1 1 1 1 0
		1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
		1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
		1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
		0 1 1 1 1 1 1 1 1 1 1 1 1 1 0
		0 1 1 1 1 1 1 1 1 1 1 1 1 1 0
		0 0 1 1 1 1 1 1 1 1 1 1 1 0 0
		0 0 0 1 1 1 1 1 1 1 1 1 0 0 0
		0 0 0 0 1 1 1 1 1 1 1 0 0 0 0
		0 0 0 0 0 0 1 1 1 0 0 0 0 0 0];
G_temp = G_out;
padding = zeros(N+14, N+14);
padding(8:N+7, 8:N+7) = G_out;
for i = 1:7
	padding(i,:) = padding(16-i,:);
	padding(:,i) = padding(:,16-i);
	padding(N-1+i,:) = padding(N+15-i,:);
	padding(:,N-1+i) = padding(:,N-15+i);
end
for i = 8:N+7
	for j = 8:N+7
		temp = padding(i-7:i+7, j-7:j+7);
		temp2 = temp(:) .* mask2(:);
		temp2(temp2 == 0) = [];
		G_out(i-7,j-7) = min(temp2);
	end
end
% figure;
% imshow(G_out, [0,255]);
fid2=fopen('bonus.raw','wb');
Towrite=permute(G_out, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);