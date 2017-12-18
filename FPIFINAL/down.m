function down(image, dsfactor) % patchsize constant = 4

    H = imread(image); 
    %H = rgb2gray(H);
    [Rows, Cols, Channels] = size(H);
    G = [0.0625 0.125 0.0625; 0.125 0.25 0.125; 0.0625 0.125 0.0625] ;
    np = [0.25 0.25; 0.25 0.25]; % patchsize 2x2 always
    
    % testing the downscalling factor, so we can get a kernel for median
    % filter which is a low pass filter. if the factor is not int, he
    % should be truncated. Kernels with 1 valeu means no downscalling at
    % all. Kernels above 5 should make image so small that we can even see.
    if round(dsfactor) == 2
        kernel = [ 0.25 0.25 ; 0.25 0.25 ]; end
    
    if round(dsfactor) == 3
        kernel = [0.11 0.11 0.11; 0.11 0.11 0.11; 0.11 0.11 0.11]; 
    end
    if round(dsfactor) == 4
        kernel = [0.0625 0.0625 0.0625 0.0625; 0.0625 0.0625 0.0625 0.0625;
            0.0625 0.0625 0.0625 0.0625; 0.0625 0.0625 0.0625 0.0625];
    end
    
    % 1.first we do a convolution with a low pass kernel and the input_img
    L = conv2(H, kernel, 'valid');
    
    % 2.then we subsample this convolution result with factor pixels

    
    [Rows, Cols, Channels] = size(L);
    exites = uint8(zeros(size(L)));
    for x = 1:2:Rows
        for y = 1:2:Cols
          if x >= Rows 
            k =  L(x,y);
          elseif y >= Cols 
            k =  L(x,y);
          else
            k =  (L(x,y) + L(x+1,y) + L(x,y+1) + L(x+1,y+1))/4;
          end
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    L = output;
    
    figure

    
    % 3.another convolution now with the input image scalled by a *2
    
    L2 = imresize(H, 2);
    L2 = conv2(L2, kernel, 'valid');
    
    [Rows, Cols, Channels] = size(L2);
    exites = uint8(zeros(size(L2)));
    for x = 1:2:Rows
        for y = 1:2:Cols
          if x >= Rows 
            k =  L2(x,y);
          elseif y >= Cols 
            k =  L2(x,y);
          else
            k =  (L2(x,y) + L2(x+1,y) + L2(x,y+1) + L2(x+1,y+1))/4;
          end
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    L2 = output;

    % 4. now a convolution with the patchsize
    
    M = conv2(L, np, 'valid');
    
    subplot(3,3,3);
    imshow(uint8(M));
    title('M')
    % 5.
    Sl = imresize(L, 2);

    Sl = conv2(Sl, np, 'valid');
    
    Ms = imresize(M, 2);
    [RowsMs,ColsMs] = size(Ms);
    Ms = imresize(Ms,[RowsMs+1 ColsMs+1]);
    Sl = Sl - Ms;
    subplot(3,3,4)
    imshow(uint8(Sl));
    title('Sl - Ms');

    
   
    % 6.
    
    Sh = conv2(L2, np, 'valid');
    Sh = Sh - Ms;
    
    subplot(3,3,5)
    imshow(uint8(Sh));
    title('Sh-Ms')
    
    % 7.
    X = sqrt(Sh ./ Sl);
    R = imresize(X, 0.5);
    
    % 8. 
    [XRols,XCols] = size(R);
    for j = 1:XRols
      for i = 1:XCols
        if X(j,i) <  0.000001
          X(j,i) = 0;
        end
      end
    end
      
    % 9.
    
    Im = uint8(ones(size(M)));
    N = conv2(Im, np, 'full');
    
    subplot(3,3,6)
    imshow(uint8(X));
    title('X');
    
    % 10.
    [RowsR,ColsR] = size(R);
    R = imresize(R,[RowsR-1 ColsR-1]);
    
    T = conv2(R .* M, np, 'full');

    
    % 11.
    
    M  = conv2(M, np, 'full');
    subplot(3,3,1);
    imshow(uint8(M));
    title('M');
    
    % 12.
    
    R = conv2(R, np, 'full');
    

    % 13. end
    
    [mr, mc] = size(M);

    %R = reshape(M, mr, mc);
    %L = reshape(M, mr, mc);
    %T = reshape(M, mr, mc);
    %N = reshape(M, mr, mc);
    
    D = uint8(abs(R)) .* uint8(abs(L));
    subplot(3,3,7)
    imshow(uint8(D));
    title('D .* L');
    
    D = uint8(M) + uint8(D);
    subplot(3,3,8);
    imshow(uint8(D));
    title(' M + D( R.* L)');
    
    D = uint8(abs(D)) - uint8(abs(T));
    subplot(3,3,9);
    imshow(uint8(D));
    title(' M+D(R .* L) - T');
    
    D = uint8(D) ./ uint8(N);
    
        
    subplot(3,3,2);
    imshow(uint8(D));
    title('(M+D+R*L-T)/N');
    

    % show me truth with mangekÿo sharingan
    %figure
    %subplot(1,2,1);
    %title('original');
    %imshow(H);
    %subplot(1,2,2);
    %title('downscalledboi');
    %imshow(uint8(D));
end
  
  
  
