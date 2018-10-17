filename = 'sample1.raw';
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
G_origin = G;

G_new = G;
for i = 3:N-2
	for j = 3:N-2
		temp = G(i-2:i+2, j-2:j+2);
		G_new(i,j) = median(sort(reshape(temp, [1,25])));
	end
end

G = G_new;
% imshow(G, [0,255]);

%1st order
G3P = zeros(N,N);
for i = 1:N-1
	for j = 2:N
		G3P(i,j) = sqrt((G(i,j)-G(i,j-1))^2 + (G(i,j)-G(i+1,j))^2);
	end
end
% [count,bin] = hist(G3P(:), 0:255);
% temp = stem(bin,count, 'Marker','none');
TD3P = 30;
for i = 1:N
	for j = 1:N
		if G3P(i,j) > TD3P
			G3P(i,j) = 1;
		else
			G3P(i,j) = 0;
		end
	end
end
% figure;
% imshow(G3P, [0,1]);
% imwrite(G3P, 'G3P.jpg');

G4P = zeros(N,N);
for i = 1:N-1
	for j = 1:N-1
		G4P(i,j) = sqrt((G(i,j)-G(i+1,j+1))^2+(G(i,j+1)-G(i+1,j))^2);
	end
end
% [count,bin] = hist(G4P(:), 0:255);
% temp = stem(bin,count, 'Marker','none');
TD4P = 40;
for i = 1:N
	for j = 1:N
		if G4P(i,j) > TD4P
			G4P(i,j) = 1;
		else
			G4P(i,j) = 0;
		end
	end
end
% figure;
% imshow(G4P, [0,1]);
% imwrite(G4P, 'G4P.jpg');

K = 2;
GR = 0;
GC = 0;
G9P = zeros(N,N);
for i = 2:N-1
	for j = 2:N-1
		GR = ((G(i-1,j+1)+K*G(i,j+1)+G(i+1,j+1))-(G(i-1,j-1)+K*G(i,j-1)+G(i+1,j-1))) / (K+2);
		GC = ((G(i-1,j-1)+K*G(i-1,j)+G(i-1,j+1))-(G(i+1,j-1)+K*G(i+1,j)+G(i+1,j+1))) / (K+2);
		G9P(i,j) = sqrt(GR^2+GC^2);
	end
end
TD9P = 40;
for i = 1:N
	for j = 1:N
		if G9P(i,j) > TD9P
			G9P(i,j) = 1;
		else
			G9P(i,j) = 0;
		end
	end
end
% figure;
% imshow(G9P, [0,1]);
% imwrite(G9P, 'G9P.jpg');
fid2=fopen('1a_1st.raw','wb');
Towrite=permute(G9P, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);

%2nd order
window1 = 3;
b = 1;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
RG = zeros(N,N);
for i = 2:N-1
	for j = 2:N-1
		temp = G(i-1:i+1, j-1:j+1);
		temp2 = 0;
		for k = 1:9
			temp2 = temp2 + temp(k) * mask(k);
		end
		RG(i, j) = temp2;
	end
end
G4nb = RG;
% mask = [0 -1 0; -1 4 -1; 0 -1 0] / 4;
% mask = [-1 -1 -1; -1 8 -1; -1 -1 -1] / 8;
mask = [-2 1 -2; 1 4 1; -2 1 -2] / 8;
for i = 2:N-1
	for j = 2:N-1
		temp = RG(i-1:i+1, j-1:j+1);
		temp2 = 0;
		for k = 1:9
			temp2 = temp2 + temp(k) * mask(k);
		end
		G4nb(i,j) = temp2;
	end
end
G4nb_copy = G4nb;
TD = 2;
for i = 2:N-1
	for j = 2:N-1
		if abs(G4nb(i,j)) < TD
			G4nb(i,j) = 0;
		end
	end
end
% figure;
% imshow(G4nb, [0,1]);
G4nb_edge = zeros(N,N);
for i = 2:N-1
	for j = 2:N-1
		if G4nb(i,j) == 0
			if G4nb(i-1,j) * G4nb(i+1,j) < 0
				G4nb_edge(i,j) = 1;
			elseif G4nb(i-1,j-1) * G4nb(i+1,j+1) < 0
				G4nb_edge(i,j) = 1;
			elseif G4nb(i,j-1) * G4nb(i,j+1) < 0
				G4nb_edge(i,j) = 1;
			elseif G4nb(i-1,j+1) * G4nb(i+1,j-1) < 0
				G4nb_edge(i,j) = 1;
			end
		end
	end
end
% figure;
% imshow(G4nb_edge, [0,1]);
% imwrite(G4nb_edge, 'G8s.jpg');
fid2=fopen('1a_2nd.raw','wb');
Towrite=permute(G4nb_edge, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);

%canny
K = 2;
GR = ones(N,N);
GC = zeros(N,N);
theta = zeros(N,N);
G9P = G;
for i = 2:N-1
	for j = 2:N-1
		GR(i,j) = ((G(i-1,j+1)+K*G(i,j+1)+G(i+1,j+1))-(G(i-1,j-1)+K*G(i,j-1)+G(i+1,j-1))) / (K+2);
		GC(i,j) = ((G(i-1,j-1)+K*G(i-1,j)+G(i-1,j+1))-(G(i+1,j-1)+K*G(i+1,j)+G(i+1,j+1))) / (K+2);
		theta(i,j) = abs(atand(GC(i,j)/GR(i,j)));
		G9P(i,j) = sqrt(GR(i,j)^2+GC(i,j)^2);
	end
end

for i = 2:N-1
	for j = 2:N-1
		if ((theta(i,j) >= 0) && (theta(i,j) <= 22.5) || (theta(i,j) >= 157.5) && (theta(i,j) <= 180))
            theta(i,j) = 0;
        elseif ((theta(i,j) >= 22.5) && (theta(i,j) <= 67.5))
            theta(i,j) = 45;
        elseif ((theta(i,j) >= 67.5) && (theta(i,j) <= 112.5))
            theta(i,j) = 90;
        elseif ((theta(i,j) >= 112.5) && (theta(i,j) <= 180))
            theta(i,j) = 135;
        end
    	if theta(i,j) == 0
    		if (G9P(i,j) > G9P(i,j+1) && G9P(i,j) > G9P(i,j-1))
    			G9P(i,j) = G9P(i,j);
    		else
    			G9P(i,j) = 0;
    		end
    	elseif theta(i,j) == 45
    		if (G9P(i,j) > G9P(i+1,j-1) && G9P(i,j) > G9P(i-1,j+1))
    			G9P(i,j) = G9P(i,j);
    		else
    			G9P(i,j) = 0;
    		end
    	elseif theta(i,j) == 90
    		if (G9P(i,j) > G9P(i+1,j) && G9P(i,j) > G9P(i-1,j))
    			G9P(i,j) = G9P(i,j);
    		else
    			G9P(i,j) = 0;
    		end
    	elseif theta(i,j) == 135
    		if (G9P(i,j) > G9P(i+1,j+1) && G9P(i,j) > G9P(i-1,j-1))
    			G9P(i,j) = G9P(i,j);
    		else
    			G9P(i,j) = 0;
    		end
    	end
    end
end

TL = 10;
TH = 40;
G_canny = zeros(N,N);
for i = 2:N-1
	for j = 2:N-1
		temp = G9P(i-1:i-1, j-1:j+1);
		if G9P(i,j) > TH
			G_canny(i,j) = 1;
		elseif G9P(i,j) < TL
			G_canny(i,j) = 0;
		elseif sum(sum(temp > TH)) > 0
			G_canny(i,j) = 1;
		else
			G_canny(i,j) = 0;
		end
	end
end
% figure;
% imshow(G_canny, [0,1]);
% imwrite(G_canny, 'G_canny.jpg');
fid2=fopen('1a_canny.raw','wb');
Towrite=permute(G_canny, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);