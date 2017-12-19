
function down(image, dsfactor) % patchsize constant = 4 > 2x2 kernel

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
    
    % 2 convolution H, P(s)
    Temp = conv2(H, kernel, 'valid');
    
    % 2.2 SubSample(ConvValid(H, P(s)), s)
    % SubSample(Temp, P(s)
    
    % SubSample procedure
    [Rows, Cols, Channels] = size(Temp);
    exites = uint8(zeros(size(Temp)));
    for x = 1:2:Rows
        for y = 1:2:Cols
          if x >= Rows 
            k =  Temp(x,y);
          elseif y >= Cols 
            k =  Temp(x,y);
          else
            k =  (Temp(x,y) + Temp(x+1,y) + Temp(x,y+1) + Temp(x+1,y+1))/4;
          end
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    
    L = output; % L = SubSample(ConvValid(H, P(s)), s);
    
    % start the prints:
    %figure
    %subplot(4,4,1);
    %imshow(uint8(L));
    %title('uint8(L);');
   
    % 3. Resize H for H²

    H2 = imresize(H, 2); 
    
    % 3.1 Temp2 = ConvValid(H2, P(s));
    
    Temp2 = conv2(H2, kernel, 'valid');
    
    % 3.2 L2 = SubSample(Temp2, s);
    
    [Rows, Cols, Channels] = size(Temp2);
    exites = uint8(zeros(size(Temp2)));
    for x = 1:2:Rows
        for y = 1:2:Cols
          if x >= Rows 
            k =  Temp2(x,y);
          elseif y >= Cols 
            k =  Temp2(x,y);
          else
            k =  (Temp2(x,y) + Temp2(x+1,y) + Temp2(x,y+1) + Temp2(x+1,y+1))/4;
          end
          exites(x,y) =  k;
          exites(x+1,y) =  k;
          exites(x+1,y+1) =  k;
          exites(x,y+1) =  k;
        end       
    end
    output = imresize(exites,[Rows/2 Cols/2]);
    
    L2 = output;
    
    % L2 print
    
    %subplot(4,4,2);
    %imshow(uint8(L2));
    %title('uint8(L2);');
    
    % 4. M = ConvValid(L , np );
    
    M = conv2(L, np, 'valid');
    
    % 5. Resize L for L²
    
    Lsquare = imresize(L, 2);
    
    % 5.1 Sl = ConvValid(Lsquare, np);
    
    Sl = conv2(Lsquare, np, 'valid');
    
    %subplot(4,4,3);
    %imshow(uint8(Sl));
    %title('uint8(Sl)');
    
    % 5.2 resize M for M²
    
    M2 = imresize(M, 2);
    
    % 5.3 Sl = ConvValid(Lsquare,np) - M2;
    
     [TempR,TempC] = size(Sl);
     Sl = imresize(Sl,[TempR-1 TempC-1]);
   
    Sl = Sl - M2;
    
    %subplot(4,4,4);
    %imshow(uint8(Sl));
    %title('uint8(Sl - M2)');
    
    % 6. Sh = ConvValid(L2, np);
    
    Sh = conv2(L2, np, 'valid');
    
    %subplot(4,4,5);
    %imshow(uint8(Sh));
    %title('uint8(Sh)');
    
    % 6.1 Sh = ConvValid(L2, np) - M2;
    
    [TempR,TempC] = size(Sh);
    Sh = imresize(Sh,[TempR-1 TempC-1]);
    
    Sh = Sh - M2;
    
    %subplot(4,4,6);
    %imshow(uint8(Sh));
    %title('uint8(Sh - M2)');
    
    % 7. Rtemp = Sh ./ Sl
    
    Rtemp = Sh ./ Sl;
    
    %subplot(4,4,7);
    %imshow(uint8(Rtemp));
    %title('uint8(Rtemp = Sh ./ Sl)');
    
    % 7.1 sqrt(Rtemp);
    
    Rtemp = sqrt(Rtemp);
    
    %subplot(4,4,8);
    %imshow(uint8(Rtemp));
    %title('uint8(Rtemp = sqrt(Rtemp))');
    
    % 8. R(Sl < e) <- 0
    
    [XRols,XCols] = size(Rtemp);
    for j = 1:XRols
      for i = 1:XCols
        k = Rtemp(j,i) - Sl(j,i);
        if k <  0.000001
          Rtemp(j,i) = 0;
        end
      end
    end
    R = imresize(Rtemp, 0.5); 
    
    %subplot(4,4,9);
    %imshow(uint8(R));
    %title('uint8(R)');
    
    % 9. N = convFull(Im, np)
    
    Im = uint8(ones(size(M)));
     
    N = conv2(Im, np, 'full');
     
    %subplot(4,4,10);
    %imshow(uint8(N));
    %title('uint8(N)');
    
    % 10. RXM = R .* M.
    RXM = R .* M;
    
    %subplot(4,4,11);
    %imshow(uint8(RXM));
    %title('uint8(RXM)');
    
    % 10.1 T = convFull(RXM, np);
    
    T = conv2(RXM, np, 'full');
    
    %subplot(4,4,12);
    %imshow(uint8(T));
    %title('uint8(T)');
    
    % 11. M = convFull(M, np)
             
    M = conv2(M, np,'full');
    
    %subplot(4,4,13);
    %imshow(uint8(M));
    %title('uint8(M) conv2(M, np)');
    
    % 12. R = convFull(Rtemp, np);
    
    R = conv2(R, np, 'full');
    
    %subplot(4,4,14);
    %imshow(uint8(R));
    %title('uint8(R) conv2(Rtemp, np)');
    
    % 13.1 RL = R .* L;
    
    RL = double(R) .* double(L);
    
    %subplot(4,4,15);
    %imshow(uint8(RL));
    %title('uint8(RL) R .* L');
    
    % 13.2 MRL = M + RL;
    
    MRL = M + RL;
    
    % 13.3 MRLT = MRL - T;
    
    MRLT = MRL - T;
    
    % 13.4 MRLTN = MRLT ./ N;
    
    MRLTN = MRLT ./ N;
    
    D = MRLTN;
    
    %subplot(4,4,16);
    %imshow(uint8(D));
    %title('uint8(D) downscalled)');
    
    %disp(size(D)); % downscalled img 128x128 vs 256x256 original image!
    %disp(size(H));
    
    figure
    subplot(1,2,1);
    imshow(uint8(H));
    axis on
    title('Input Image');
    
    subplot(1,2,2);
    imshow(uint8(abs(D)))
    axis on
    title('DownScalled Image');
        

    
    
end