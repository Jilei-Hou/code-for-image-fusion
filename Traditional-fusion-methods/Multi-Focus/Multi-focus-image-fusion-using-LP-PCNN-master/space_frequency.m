function SF=space_frequency(X)%计算空间频率
X=double(X);
[n0,n0]=size(X);%%%%   X是一个方阵
X=double(X);                          %空间频率;
RF=0;
CF=0;

for fi=1:n0
    for fj=2:n0
        RF=RF+(X(fi,fj)-X(fi,fj-1)).^2;
    end
end

RF=RF/(n0*n0);

for fj=1:n0
    for fi=2:n0
        CF=CF+(X(fi,fj)-X(fi-1,fj)).^2;
    end
end

CF=CF/(n0*n0);%%%%可以思考，空间频率是不是只描述一个方阵

SF=sqrt(RF+CF)