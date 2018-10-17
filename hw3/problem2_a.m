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
% imshow(G, [0,255]);
LAWS = zeros(3,3,9);
LAWS(:,:,1) = [1 2 1; 2 4 2; 1 2 1] / 36;
LAWS(:,:,2) = [1 0 -1; 2 0 -2; 1 0 -1] / 12;
LAWS(:,:,3) = [-1 2 -1; -2 4 -2; -1 2 -1] / 12;
LAWS(:,:,4) = [-1 -2 -1; 0 0 0; 1 2 1] / 12;
LAWS(:,:,5) = [1 0 -1; 0 0 0; -1 0 1]/4;
LAWS(:,:,6) = [-1 2 -1; 0 0 0; 1 -2 1]/4;
LAWS(:,:,7) = [-1 -2 -1; 2 4 2; -1 -2 -1]/12;
LAWS(:,:,8) = [-1 0 1; 2 0 -2; -1 0 1]/4;
LAWS(:,:,9) = [1 -2 1; -2 4 -2; 1 -2 1]/4;
M = zeros(N,N,9);
for i = 1:9
	M(:,:,i) = conv2(G, LAWS(:,:,i), 'same');
end
T = zeros(N,N,9);
PADDING = zeros(N+14,N+14,9);
for i = 1:9
	PADDING(8:N+7,8:N+7,i) = M(:,:,i);
	for j = 1:7
		PADDING(j,:,i) = PADDING(16-j,:,i);
		PADDING(N+15-j,:,i) = PADDING(N-1+j,:,i);
		PADDING(:,j,i) = PADDING(:,16-j,i);
		PADDING(:,N+15-j,i) = PADDING(:,N-1+j,i);
	end
end
for x = 1:9
	for i = 8:N+7
		for j = 8:N+7
			temp = 0;
			for k = i-7:i+7
				for l = j-7:j+7
					temp = temp + PADDING(k,l,x)^2;
				end
			end
			T(i-7,j-7,x) = temp;
		end
	end
end
% figure;
% imshow(T(:,:,1), [min(min(T(:,:,1))),max(max(T(:,:,1)))]);
% figure;
% imshow(T(:,:,2), [min(min(T(:,:,2))),max(max(T(:,:,2)))]);
% figure;
% imshow(T(:,:,3), [min(min(T(:,:,3))),max(max(T(:,:,3)))]);
% figure;
% imshow(T(:,:,4), [min(min(T(:,:,4))),max(max(T(:,:,4)))]);
% figure;
% imshow(T(:,:,5), [min(min(T(:,:,5))),max(max(T(:,:,5)))]);
% figure;
% imshow(T(:,:,6), [min(min(T(:,:,6))),max(max(T(:,:,6)))]);
% figure;
% imshow(T(:,:,7), [min(min(T(:,:,7))),max(max(T(:,:,7)))]);
% figure;
% imshow(T(:,:,8), [min(min(T(:,:,8))),max(max(T(:,:,8)))]);
% figure;
% imshow(T(:,:,9), [min(min(T(:,:,9))),max(max(T(:,:,9)))]);
% tochoose = [1 1 0 0 1 0 1 1 0];
tochoose = [1 1 0 0 1 0 1 1 0];
tokmeans = zeros(N*N, 9);
for i = 1:N
	for j = 1:N
		for k = 1:9
			tokmeans((i-1)*N+j, k) = T(i,j,k)*tochoose(k);
		end
	end
end
% tokmeans = zeros(N*N, )
rng(3)
idx = kmeans(tokmeans, 3);
K = zeros(N,N);
for i = 1:N*N
	if mod(i,N) == 0
		K(ceil(i/N), N) = idx(i);
		continue;
	end
	K(ceil(i/N), mod(i,N)) = idx(i);
end
% figure;
% imshow(K, [0, 3]);

fid2=fopen('K.raw','wb');
Towrite=permute(K, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);