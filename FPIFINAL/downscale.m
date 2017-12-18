function downscale(image, dsfactor) % patchsize constant = 4

    H = imread(image); 
    %H = rgb2gray(H);
    [Rows, Cols, Channels] = size(H);
    
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
    L = conv2(H, kernel, 'same');
    
    % 2.then we subsample this convolution result with factor pixels

    exites = uint8(zeros(size(L)));
    
    for x = 1:2:Rows
        for y = 1:2:Cols
          k =  (L(x,y) + L(x+1,y) + L(x,y+1) + L(x+1,y+1))/4;
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    L = output;
    figure
    subplot(3, 3, 1);
    imshow(uint8(L));
    title('L')
    
    % 3.another convolution now with the input image scalled by a *2
    
    L2 = imresize(H, 2);
    L2 = conv2(L2, kernel, 'same');
    
    exites = uint8(zeros(size(L2)));
    
    [Rows, Cols, Channel] = size(L2);
    for x = 1:2:Rows
        for y = 1:2:Cols
          k =  (L2(x,y) + L2(x+1,y) + L2(x,y+1) + L2(x+1,y+1))/4;
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    
    L2 = output;
    subplot(3,3,2);
    imshow(uint8(L2));
    title('L2')
    % 4. now a convolution with the patchsize
    
    M = conv2(L, np, 'same');
    
    subplot(3,3,3);
    imshow(uint8(M));
    title('M')
    % 5.
    Sl = imresize(L, 2);
    Sl = conv2(Sl, np, 'same');
    
    Ms = imresize(M, 2);
    Sl = Sl - Ms;
    
    subplot(3,3,4)
    imshow(uint8(Sl));
    title('Sl - Ms');
    % 6.
    
    Sh = conv2(L2, np, 'same');
    Sh = Sh - Ms;
    
    subplot(3,3,5)
    imshow(uint8(Sh));
    title('Sh-Ms')
    
    % 7.
    X = Sh ./ Sl;
    R = imresize(X, 0.5);
    
    % 8. 
    if Sl < 0.000001
        R = uint8(zeros(size(Sl)));
    end
      
    % 9.
    
    Im = uint8(zeros(size(M)));
    N = conv2(Im, np, 'same');
    
    subplot(3,3,6)
    imshow(uint8(X));
    title('X');
    
    % 10.
    T = conv2(R .* M, np, 'same');
    subplot(3,3,7);
    imshow(uint8(T));
    title('T');
    
    % 11.
    
    M  = conv2(M, np, 'same');
    
    % 12.
    
    R = conv2(R, np, 'same');
    
    subplot(3,3,8)
    imshow(uint8(R));
    title('R');
    % 13. end
    D = (uint8(M) + (uint8(R) .* uint8(L)) - uint8(T)) ./ uint8(N); 
    
    subplot(3,3,9);
    imshow(uint8(D));
    title('downscalled');
    % show me truth with mangekÿo sharingan
    %figure
    %subplot(1,2,1);
    %title('original');
    %imshow(H);
    %subplot(1,2,2);
    %title('downscalledboi');
    %imshow(uint8(D));
end


   
    
    


    
    



