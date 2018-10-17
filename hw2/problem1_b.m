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

window1 = 3;
b = 2;
mask = [1 b 1; b b^2 b; 1 b 1] / (b+2)^2;
G_new = G;
for i = 2:N-1
    for j = 2:N-1
        temp = G(i-1:i+1, j-1:j+1);
        temp2 = 0;
        for k = 1:9
            temp2 = temp2 + temp(k) * mask(k);
        end
        G_new(i, j) = temp2;
    end
end
G = G_new;

G_new = G;
for i = 3:N-2
    for j = 3:N-2
        temp = G(i-2:i+2, j-2:j+2);
        G_new(i,j) = median(sort(reshape(temp, [1,25])));
    end
end
% figure;
% imshow(G_new, [0,255]);
G = G_new;

K = 1;
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
TH = 35;
TL = 10;
G_1b = zeros(N,N);
for i = 2:N-1
	for j = 2:N-1
		temp = G9P(i-1:i-1, j-1:j+1);
		if G9P(i,j) > TH
			G_1b(i,j) = 1;
		elseif G9P(i,j) < TL
			G_1b(i,j) = 0;
		elseif sum(sum(temp > TH)) > 0
			G_1b(i,j) = 1;
		else
			G_1b(i,j) = 0;
		end
	end
end
% figure
% imshow(G_1b, [0,1]);
% imwrite(G_1b, 'G_1b.jpg');
fid2=fopen('1b.raw','wb');
Towrite=permute(G_1b, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);