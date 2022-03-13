function R = ReconstructGradient(gxH,gyH,meanval,PoissonOn)
%
%% Wavelet based Image Reconstruction from Gradient Data
%
% Version 1.0
% I. Sevcenco, P. Hampton, P. Agathoklis
% Department of Electrical and Computer Engineering
% University of Victoria
% Victoria, B.C., Canada
% Detailed explaination of this code at : http://www.mathworks.com/matlabcentral/fileexchange/48066-wavelet-based-image-reconstruction-from-gradient-data
%
% Description of the function :
%     This function can be used to reconstruct an image from gradient data.
%     It can be used to reconstruct images that are either single channel
%     (i.e., grayscale) or multi channel (i.e., colour, in three channel
%     representation, such as RGB). The theory behind this toolbox was
%     developed in the papers [1], [2] and [3].
%
% INPUT specifications :
%     gxH and gyH = gradients used to reconstruct the image;
%                   These should be two matrices of the same size
%                   as the image to be reconstructed. (last column in gxH
%                   should be 0; last row in gyH should be 0)
%     meanval =     For color images, it should be a 3 x 1 vector storing
%                   the mean values of the image we want to reconstruct
%                   (one scalar per channel, meanval(1) for Red, meanval(2)
%                   for to Green, meanval(3) for Blue channel
%     PoissonOn =   binary flag for Poisson solver during reconstruction
%                   0 if Poisson solver is not used during reconstruction
%                   else 1
%
% REFERENCES
%
% [1] I.S. Sevcenco, P.J. Hampton, P. Agathoklis, "A wavelet based method
% for image reconstruction from gradient data with applications",
% Multidimensional Systems and Signal Processing, November 2013
%
% Earlier references using Fried gradient discretization (see sec. 2.1. in [1]):
%
% [2] P.J. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
% Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
% Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
%
% [3] P.J. Hampton, P. Agathoklis, "Comparison of Haar Wavelet-based and Poisson-based
% Numerical Integration Techniques", Proceedings of Circuits and Systems
% (ISCAS), pp.1623-1626, 2010

R = ImageRecH(gxH,gyH,meanval,PoissonOn,3);

    function I = CombineRGB(R,G,B)
        % Program CombineRGB.m
        % This program generates a three channel image (e.g., RGB, YCbCr, etc.)
        % from three single channel components.
        %
        % Inputs:
        %   R,G,B = the three channels of the image;
        %           must be two dimensional arrays, with the first dimension
        %           corresponding to the height ofthe image, and the second corresponding
        %           to the width of the image
        % Output:
        %   I = the multi-channel (color) image
        if isequal(size(R),size(G),size(B))==0,
            disp('Sizes of the three arrays must be equal. Please check input data for consistency');
            return
        else
            I = zeros([size(R),3]);
            I(:,:,1) = R;
            I(:,:,2) = G;
            I(:,:,3) = B;
        end
    end

    function [dxF,dyF] = ConvertGradientHF(dxH,dyH)
        % Converts gradients computed in Hudgin into Fried geometry
        % (please see Sec.2.2 in Reference 1 for discretization equations).
        % Input:
        %       dxH, dyH = gradient data computed via Hudgin geometry
        % Output:
        %       dxF, dyF = gradient data computed via Fried geometry
        %
        % Note: If an image is (m x n)
        %       the Hudgin gradients will be dx (m x n-1) and dy (m-1 x n)
        %       the Fried gradients will be (m-1 x n-1)
        % References:
        % 1. I. S. Sevcenco, P. Hampton, P. Agathoklis, "A wavelet based method
        % for image reconstruction from gradient data with applications",
        % Multidimensional Systems and Signal Processing, November 2013
        dxF = 0.5*(dxH(1:end-1,:,:) + dxH(2:end,:,:));
        dyF = 0.5*(dyH(:,1:end-1,:) + dyH(:,2:end,:));
    end

    function I = CorrectMeanValue(I,m_desired)
        % Program CorrectMeanValue.m
        % =======================================================
        % This function changes the mean value of a 2D array
        % (e.g., a *one channel* image) to match
        % a desired value (correction is done by uniform shifting)
        %
        % Input:
        %   I = 2D array (one channel image, with the first dimension corresponding
        %       to the image height, and the second the image width)
        %   m_desired = a scalar indicating the desired mean value
        % Output:
        %   I = 2D array with the values shifted such that the mean value is m_desired
        %
        % Example:
        %   I = imread('eight.tif');
        %   Is = CorrectMeanValue(I,120);
        %
        % Note:
        %   The values are not clipped back to [0..255]
        %   The type of the output is 'double'
        I = double(I);
        [r,c] = size(I);
        I = I(:);
        m_input = mean(I);
        d = m_desired - m_input;
        I = I + d;
        I = reshape(I,r,c);
    end

    function [div, curl] = getDiv(dPdx,dPdy)
        if max(size(dPdx)) > 1
            [dPdxdx, dPdxdy] = getGradient(2*dPdx);
            [dPdydx, dPdydy] = getGradient(2*dPdy);
            div = dPdxdx + dPdydy;
            curl = -dPdxdy + dPdydx; %zero for no noise
        else
            %not enough data
            div = 0;
            curl = 0;
        end
    end

    function [dzdx, dzdy] = getGradient(ConservativeField)
        % program getGradient.m
        % This program computes the Fried derivatives of a 2D array;
        % Input:
        %   ConservativeField = 2d array, such as a grayscale digital image
        % Output:
        %   dzdx, dzdy = Fried gradient horizontal and vertical components
        % Commented by: I. Sevcenco,
        dzdx = ConservativeField(:,2:end,:) - ConservativeField(:,1:end-1,:);
        dzdx = dzdx(2:end,:,:) + dzdx(1:end-1,:,:);
        dzdx = dzdx*0.5;
        dzdy = ConservativeField(2:end,:,:) - ConservativeField(1:end-1,:,:);
        dzdy = dzdy(:,2:end,:) + dzdy(:,1:end-1,:);
        dzdy = dzdy*0.5;
    end

    function L_P = getLaplacian(P)
        L_P = conv2(P,[-1 0 -1;0 4 0;-1 0 -1]);
        L_P = -L_P(3:end-2,3:end-2);
    end

    function [D, X, Y] = GradientAnalysis(dzdx,dzdy)
        % GradientAnalysis.m
        %   Performs the analysis of gradient data generated by getGradient.m
        %   D is the decomposition
        %   X and Y are multigrid representations of the filtered X and Y data that
        %   has use in the smoothing portion of synthesis.
        % Reference:
        %   P. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
        %   Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
        %   Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
        %
        % Written by:  Peter Hampton
        %   Copyright August 2008
        % Commented by: Ioana Sevcenco
        %% Truncates data size to avoid long delays or crashes due to memory allocation issues.
        % Delete/ comment this if you want data sets larger than 4 Mpixels
        % [nr nc] = size(dzdx);
        % if nr > 2047
        %     dzdx = dzdx(1:2047,:);
        %     dzdy = dzdy(1:2047,:);
        % end
        % if nc > 2047
        %     dzdx = dzdx(:,1:2047);
        %     dzdy = dzdy(:,1:2047);
        % end
        %%
        [dzdx, dzdy] = Reflect(dzdx,dzdy);
        M = ceil(log2(size(dzdx)));
        
        M = max(M);
        N = 2^M;
        offset = 0.5*N;
        m = 0:M;
        iS = 2.^m + 1; % start index
        iE = 2.^(m+1); % end index
        iSD = ceil(2.^(m-1)) + 1;
        iED = 2.^m;
        X(1:iS(M+1)-1,iS(M+1):iE(M+1)) = dzdx;
        Y(1:iS(M+1)-1,iS(M+1):iE(M+1)) = dzdy;
        U = 0*dzdx;
        V = 0*dzdy;
        D = 0*dzdx;
        for m = M:-1:1;
            
            U(1:iS(m)-2,iS(m):iE(m)-1) = X(1:2:iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
                + X(1:2:iS(m+1)-3,iS(m+1)+2:2:iE(m+1));
            U(iS(m):iE(m)-1,iS(m):iE(m)-1) = X(3:2:iS(m+1)-1,iS(m+1):2:iE(m+1)-2) ...
                + X(3:2:iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
            
            % HH
            
            D(iSD(m):iED(m),iSD(m):iED(m)) = (U(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
                - U(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
                + X(3:4:iS(m+1)-1,iS(m+1)+1:4:iE(m+1)-1) ...
                - X(1:4:iS(m+1)-3,iS(m+1)+1:4:iE(m+1)-1);
            
            % Lowpass filter and downsample X
            X(1:iS(m)-2,iS(m):iE(m)-1) = (U(1:iS(m)-2,iS(m):iE(m)-1) ...
                + U(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
                + X(1:2:iS(m+1)-3,iS(m+1)+1:2:iE(m+1)-1) ...
                + X(3:2:iS(m+1)-1,iS(m+1)+1:2:iE(m+1)-1);
            
            % Downsample again to obtain HL
            D(1:iS(m)-1,iS(m):iE(m)) = X(1:2:iS(m+1)-2,iS(m+1):2:iE(m+1)-1);
            
            V(1:iS(m)-2,iS(m):iE(m)-1) = Y(1:2:iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
                + Y(3:2:iS(m+1)-1,iS(m+1):2:iE(m+1)-2);
            
            V(iS(m):iE(m)-1,iS(m):iE(m)-1) = Y(1:2:iS(m+1)-3,iS(m+1)+2:2:iE(m+1)) ...
                + Y(3:2:iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
            
            % Add solution from Y into HH
            D(iSD(m):iED(m),iSD(m):iED(m)) = D(iSD(m):iED(m),iSD(m):iED(m))...
                + (V(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
                - V(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
                + Y(2:4:iS(m+1)-2,iS(m+1)+2:4:iE(m+1)) ...
                - Y(2:4:iS(m+1)-2,iS(m+1):4:iE(m+1)-2);
            % Normalize the average
            D(iSD(m):iED(m),iSD(m):iED(m)) = D(iSD(m):iED(m),iSD(m):iED(m))*0.5;
            
            % Low pass filter and downsample Y
            Y(1:iS(m)-2,iS(m):iE(m)-1) = (V(1:iS(m)-2,iS(m):iE(m)-1) ...
                + V(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
                + Y(2:2:iS(m+1)-2,iS(m+1):2:iE(m+1)-2) ...
                + Y(2:2:iS(m+1)-2,iS(m+1)+2:2:iE(m+1));
            
            D(iS(m):iE(m),1:iS(m)-1) = Y(1:2:iS(m+1)-2,iS(m+1):2:iE(m+1)-1);
        end
        m = M;
        U(1:iS(m)-2,iS(m):iE(m)-1) = X(1:2:iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
            + X(3:2:iS(m+1)-1,iS(m+1):2:iE(m+1)-2);
        U(iS(m):iE(m)-1,iS(m):iE(m)-1) = X(1:2:iS(m+1)-3,iS(m+1)+2:2:iE(m+1)) ...
            + X(3:2:iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
        
        % HH
        D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
            (U(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
            - U(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
            + X(2:4:iS(m+1)-2,iS(m+1):4:iE(m+1)-2) ...
            - X(2:4:iS(m+1)-2,iS(m+1)+2:4:iE(m+1));
        
        % Lowpass filter and downsample X
        X(offset+1:offset+iS(m)-2,iS(m):iE(m)-1) = ...
            (U(1:iS(m)-2,iS(m):iE(m)-1) ...
            + U(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
            - X(2:2:iS(m+1)-2,iS(m+1):2:iE(m+1)-2) ...
            - X(2:2:iS(m+1)-2,iS(m+1)+2:2:iE(m+1));
        
        % Downsample again to obtain HL
        
        V(1:iS(m)-2,iS(m):iE(m)-1) = Y(1:2:iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
            + Y(1:2:iS(m+1)-3,iS(m+1)+2:2:iE(m+1));
        
        V(iS(m):iE(m)-1,iS(m):iE(m)-1) = Y(3:2:iS(m+1)-1,iS(m+1):2:iE(m+1)-2) ...
            + Y(3:2:iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
        
        % Add solution from Y into HH
        D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
            D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m))...
            + (V(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
            - V(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
            + Y(1:4:iS(m+1)-3,iS(m+1)+1:4:iE(m+1)-1) ...
            - Y(3:4:iS(m+1),iS(m+1)+1:4:iE(m+1)-1);
        % Normalize the average
        D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
            D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m))*0.5;
        
        % Low pass filter and downsample Y
        Y(offset+1:offset+iS(m)-2,iS(m):iE(m)-1) = (V(1:iS(m)-2,iS(m):iE(m)-1) ...
            + V(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
            - Y(1:2:iS(m+1)-3,iS(m+1)+1:2:iE(m+1)-1) ...
            - Y(3:2:iS(m+1)-1,iS(m+1)+1:2:iE(m+1)-1);
        
        
        for m = M-1:-1:1;
            U(1:iS(m)-2,iS(m):iE(m)-1) = X(offset+1:2:offset+iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
                + X(offset+3:2:offset+iS(m+1)-1,iS(m+1):2:iE(m+1)-2);
            U(iS(m):iE(m)-1,iS(m):iE(m)-1) = X(offset+1:2:offset+iS(m+1)-3,iS(m+1)+2:2:iE(m+1)) ...
                + X(offset+3:2:offset+iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
            
            % HH
            D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
                (U(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
                - U(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
                + X(offset+2:4:offset+iS(m+1)-2,iS(m+1)+2:4:iE(m+1)) ...
                - X(offset+2:4:offset+iS(m+1)-2,iS(m+1):4:iE(m+1)-2);
            
            % Lowpass filter and downsample X
            X(offset+1:offset+iS(m)-2,iS(m):iE(m)-1) = (U(1:iS(m)-2,iS(m):iE(m)-1) ...
                + U(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
                + X(offset+2:2:offset+iS(m+1)-2,iS(m+1):2:iE(m+1)-2) ...
                + X(offset+2:2:offset+iS(m+1)-2,iS(m+1)+2:2:iE(m+1));
            
            % Downsample again to obtain HL
            D(offset+iS(m):offset+iE(m),offset+1:offset+iS(m)-1) = (X(offset+1:2:offset+iS(m+1)-2,iS(m+1):2:iE(m+1)-1));
            
            V(1:iS(m)-2,iS(m):iE(m)-1) = Y(offset+1:2:offset+iS(m+1)-3,iS(m+1):2:iE(m+1)-2) ...
                + Y(offset+1:2:offset+iS(m+1)-3,iS(m+1)+2:2:iE(m+1));
            
            V(iS(m):iE(m)-1,iS(m):iE(m)-1) = Y(offset+3:2:offset+iS(m+1)-1,iS(m+1):2:iE(m+1)-2) ...
                + Y(offset+3:2:offset+iS(m+1)-1,iS(m+1)+2:2:iE(m+1));
            
            % Add solution from Y into HH
            D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
                D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m))...
                +(V(iS(m):2:iE(m)-1,iS(m):2:iE(m)-1) ...
                - V(1:2:iS(m)-2,iS(m):2:iE(m)-1))*0.5 ...
                + Y(offset+3:4:offset+iS(m+1)-1,iS(m+1)+1:4:iE(m+1)-1) ...
                - Y(offset+1:4:offset+iS(m+1)-3,iS(m+1)+1:4:iE(m+1)-1);
            % Normalize the average
            D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m)) = ...
                D(offset+iSD(m):offset+iED(m),offset+iSD(m):offset+iED(m))*0.5;
            
            % Low pass filter and downsample Y
            Y(offset+1:offset+iS(m)-2,iS(m):iE(m)-1) = (V(1:iS(m)-2,iS(m):iE(m)-1) ...
                + V(iS(m):iE(m)-1,iS(m):iE(m)-1))*0.5 ...
                + Y(offset+1:2:offset+iS(m+1)-3,iS(m+1)+1:2:iE(m+1)-1) ...
                + Y(offset+3:2:offset+iS(m+1)-1,iS(m+1)+1:2:iE(m+1)-1);
            
            D(offset+1:offset+iS(m)-1,offset+iS(m):offset+iE(m)) = Y(offset+1:2:offset+iS(m+1)-2,iS(m+1):2:iE(m+1)-1);
        end
    end

    function [NewD,XX,YY] = GradientAnalysisH(dxH,dyH)
        % program GradientAnalysisH.m
        % ===========================
        % This function obtains the Haar decomposition of an image from the Hudgin
        % gradients - assuming zero Neumann condition, i.e., the gradients are zero
        % on the boundary (please see Sec.2.2 in Reference 1 for discretization equations).
        % Inputs:
        %   dxH, dyH = Hudgin gradient horizontal and vertical components,
        %              respectively (Neumann boundary conditions, i.e. last row of
        %              dxH is zero, last column of dyH is zero)
        % Outputs:
        %   NewD = Haar wavelet decomposition of signal to be reconstructed
        %   XX, YY = multigrid representations of the filtered gradient data that
        %            are used in the smoothing portion of synthesis (i.e., for
        %            Poisson smoothing)
        % Written by: Ioana Sevcenco, University of Victoria
        %
        % References:
        % [1] I.S. Sevcenco, P.J. Hampton, P. Agathoklis, "A wavelet based method
        % for image reconstruction from gradient data with applications",
        % Multidimensional Systems and Signal Processing, November 2013
        %
        % [2] P.J. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
        % Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
        % Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
        %
        % First version: Jan 30, 2012
        % Last Updated: August 21st, 2014
        dxH = dxH(:,1:end-1,:); % crop out last column of zeros
        dyH = dyH(1:end-1,:,:); % crop out last row of zeros
        
        [dxH,dyH] = ReflectH(dxH,dyH); % Reflects gradient components in case
        % of non-square, non-power of two inputs
        [~,dxHy] = getGradientH(dxH); % compute second order mixed Hudgin derivative, for HH
        [dyHx,~] = getGradientH(dyH); % compute second order mixed Hudgin derivative, for HH
        HH = (dyHx+dxHy)/4; % scale back
        HH = HH(1:2:end,1:2:end);  % downsample
        
        [dxF,dyF] = ConvertGradientHF(dxH,dyH); % convert given Hudgin to to Fried derivatives
        HL = dxF(1:2:end,1:2:end); % HL obtained from Fried x gradient
        LH = dyF(1:2:end,1:2:end); % LH  obtained from Fried y gradient
        
        [D_from_algorithm,XX,YY] = GradientAnalysis(dxF,dyF);
        LL_from_algorithm = D_from_algorithm(1:end/2,1:end/2);
        
        NewD = [LL_from_algorithm HL; LH HH];
    end

    function D = GradientSynthesisH(D, X, Y, PoissonOn, no_iter)
        % GradientSynthesisH.m
        % Performs the synthesis of gradient decomposition generated by GradientAnalysisH.m
        % Inputs:
        %   D = decomposition output of gradient analysis step;
        %   X, Y = filtered and downsampled parts of the gradient, output of
        %          gradient analysis step;
        %   averageData = scalar, should be 0 or 1
        %                 set to 0 for no Poisson solver in synthesis
        %                 set to 1 to include Poisson solver in synthesis
        %   no_iter = number of iterations of Poisson solver
        % Output:
        %   D = reconstructed 2D array
        % References:
        % 1. I. S. Sevcenco, P. Hampton, P. Agathoklis, "A wavelet based method
        % for image reconstruction from gradient data with applications",
        % Multidimensional Systems and Signal Processing, November 2013
        %
        % 2. P. Hampton, P. Agathoklis, "Comparison of Haar Wavelet-based and Poisson-based
        % Numerical Integration Techniques", 2010
        %
        % 3. P. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
        % Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
        % Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
        %
        % Written by: Peter Hampton, 2008
        % Updated and commented by: Ioana Sevcenco,2012-2014
        if PoissonOn==0 && nargin < 5,
            no_iter = 0; % not used
        end
        if PoissonOn==1 && nargin < 5,
            no_iter = 3; % suggested number of iterations
        end;
        Scrap = D;
        M = log2(max(size(D)));
        twoPm = 1;
        %% Top Left
        iSq = 1:2*twoPm;
        i1 = iSq(1:end/2);
        i2 = iSq(1+end/2:end);
        D(i1,i1) = D(i1,i1) - D(i2,i1);
        D(i1,i2) = D(i1,i2) - D(i2,i2);
        D(i1,i1) = 0.5*(D(i1,i1) - D(i1,i2));
        D(i2,i1) = (D(i2,i1) - D(i2,i2));
        D(i2,i1) = D(i2,i1) + D(i1,i1);
        D(i2,i2) = D(i1,i2) + 2*D(i2,i2);
        D(i1,i2) = D(i1,i2) + D(i1,i1);
        D(i2,i2) = D(i2,i2) + D(i2,i1);
        Scrap(iSq(1:2:end-1),iSq(1:2:end-1)) = D(i1,i1);
        Scrap(iSq(1:2:end-1),iSq(2:2:end)) = D(i1,i2);
        Scrap(iSq(2:2:end),iSq(1:2:end-1)) = D(i2,i1);
        Scrap(iSq(2:2:end),iSq(2:2:end)) = D(i2,i2);
        D(iSq,iSq) = Scrap(iSq,iSq);
        for m = 1:M-2
            twoPm = 2^m;
            %% Top Left
            iSq = 1:2*twoPm;
            i1 = iSq(1:end/2);
            i2 = iSq(1+end/2:end);
            D(i1,i1) = D(i1,i1) - D(i2,i1);
            D(i1,i2) = D(i1,i2) - D(i2,i2);
            D(i1,i1) = 0.5*(D(i1,i1) - D(i1,i2));
            D(i2,i1) = (D(i2,i1) - D(i2,i2));
            D(i2,i1) = D(i2,i1) + D(i1,i1);
            D(i2,i2) = D(i1,i2) + 2*D(i2,i2);
            D(i1,i2) = D(i1,i2) + D(i1,i1);
            D(i2,i2) = D(i2,i2) + D(i2,i1);
            Scrap(iSq(1:2:end-1),iSq(1:2:end-1)) = D(i1,i1);
            Scrap(iSq(1:2:end-1),iSq(2:2:end)) = D(i1,i2);
            Scrap(iSq(2:2:end),iSq(1:2:end-1)) = D(i2,i1);
            Scrap(iSq(2:2:end),iSq(2:2:end)) = D(i2,i2);
            D(iSq,iSq) = Scrap(iSq,iSq);
            %% Average in Extra Data for top left
            if PoissonOn == true
                ir = 1:2*twoPm-1;
                ic = 2*twoPm + ir;
                iSq = 1:2*twoPm;
                for ii = 1:no_iter,
                    D(iSq,iSq) = PoissonSolveExtend(D(iSq,iSq),X(ir,ic),Y(ir,ic));
                end
            end
        end
        m = M-1;
        twoPm = 2^m;
        %% Full image
        iSq = 1:2*twoPm;
        i1 = iSq(1:end/2);
        i2 = iSq(1+end/2:end);
        D(i2,i2) = Scrap(i2,i2); % change HH to the one obtained in new analysis
        D(i1,i1) = D(i1,i1) - D(i2,i1);
        D(i1,i2) = D(i1,i2) - D(i2,i2);
        D(i1,i1) = 0.5*(D(i1,i1) - D(i1,i2));
        D(i2,i1) = (D(i2,i1) - D(i2,i2));
        D(i2,i1) = D(i2,i1) + D(i1,i1);
        D(i2,i2) = D(i1,i2) + 2*D(i2,i2);
        D(i1,i2) = D(i1,i2) + D(i1,i1);
        D(i2,i2) = D(i2,i2) + D(i2,i1);
        Scrap(iSq(1:2:end-1),iSq(1:2:end-1)) = D(i1,i1);
        Scrap(iSq(1:2:end-1),iSq(2:2:end)) = D(i1,i2);
        Scrap(iSq(2:2:end),iSq(1:2:end-1)) = D(i2,i1);
        Scrap(iSq(2:2:end),iSq(2:2:end)) = D(i2,i2);
        D(iSq,iSq) = Scrap(iSq,iSq);
        %% Full image
        if PoissonOn == true
            ir = 1:2*twoPm-1;
            ic = 2*twoPm + ir;
            iSq = 1:2*twoPm;
            for ii = 1:no_iter,
                D(iSq,iSq) = PoissonSolveExtend(D(iSq,iSq),X(ir,ic),Y(ir,ic));
            end;
        end
    end

    function  R = ImageRecH(gxH,gyH,meanval,PoissonOn,no_iter)
        % Program ImageRecH.m
        % -------------------------------------------------------------------
        % This function reconstructs an image from its Hudgin gradient
        % (please see Sec.2.2 in Ref. 1 for Hudgin gradient discretization Equations).
        % The program works for both multi-channel (e.g., color),
        % as well as for one channel (e.g., grayscale) images.
        %
        % Inputs:
        %       gxH and gyH = Hudgin gradients used to reconstruct the image;
        %                     should be two matrices of the same size
        %                     as the image to be reconstructed
        %                     (last column in gxH should be 0; last row in gyH should be 0);
        %       meanval = if the image is color, should be a 3 x 1 vector storing
        %                 the mean value of the image we want to reconstruct
        %                 (one scalar per channel, meanval(1) corresponding to R,
        %                 meanval(2) corresponding to G, meanval(3) corresponding to B
        %       PoissonOn = binary flag for Poisson solver during reconstruction
        %             can be: 0: Poisson solver is not used during reconstruction
        %                     1: Poisson solver is used during reconstruction
        %       no_iter = number of iterations used in the Poisson solver;
        %                 -- if no Poisson solver is used in the reconstruction, then
        %                 the value of no_iter is irrelevant, and set to 0 by
        %                 default;
        %                 -- if the Poisson solver is used in the reconstruction,
        %                 a suggested value for the number of iterations is three
        %                 (default)
        %                 -- the user can also specify the desired number of
        %                 iterations (acceptable values are positive integers, greater than 1)
        % Output: R = reconstructed image
        %
        % For Examples of how to use the function please consult the
        % documentation included in our submission (DocumentationToolbox.pdf)
        %
        % References:
        %
        % [1] I. S. Sevcenco, P. Hampton, P. Agathoklis, "A wavelet based method
        % for image reconstruction from gradient data with applications",
        % Multidimensional Systems and Signal Processing, November 2013
        %
        % Earlier references using Fried gradient discretization (see sec. 2.1. in [1]):
        %
        % [2] P. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
        % Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
        % Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
        %
        % [3] P. Hampton, P. Agathoklis, "Comparison of Haar Wavelet-based and Poisson-based
        % Numerical Integration Techniques", 2010
        
        % Written by: Ioana Sevcenco, University of Victoria%
        % Last updated: August 28th, 2014
        if (PoissonOn==0) && (nargin < 5),
            no_iter = 0; % not used, but defined to avoid compiling errors
        end
        if (PoissonOn==1) && (nargin < 5),
            no_iter = 3; % suggested number of iterations
        end;
        if (size(gxH,3) == 3) % i.e., if image is three channel
            [dx_rec1,dx_rec2,dx_rec3] = splitRGB(gxH);
            [dy_rec1,dy_rec2,dy_rec3] = splitRGB(gyH);
            R1 = OneChannelRec(dx_rec1,dy_rec1,PoissonOn,meanval(1),no_iter);
            R2 = OneChannelRec(dx_rec2,dy_rec2,PoissonOn,meanval(2),no_iter);
            R3 = OneChannelRec(dx_rec3,dy_rec3,PoissonOn,meanval(3),no_iter);
            R = CombineRGB(R1,R2,R3);
        else if (size(gxH,3) == 1) % i.e., if image is grayscale
                R = OneChannelRec(gxH,gyH,PoissonOn,meanval,no_iter);
            end
        end
    end

    function R = OneChannelRec(gxH,gyH,PoissonOn,meanval,no_iter)
        % Program OneChannelRec.m
        % -------------------------------------------------------------------
        % This function reconstructs a *one channel* (i.e., grayscale) image
        % from a given *Hudgin* gradient using the Hampton Haar wavelet based algorithm;
        % (please see Sec.2.2 in (1) for Hudgin gradient discretization Equations).
        % Inputs:
        %       gxH and gyH = Hudgin gradient components that will be used to reconstruct
        %                     the image; should be two matrices of the same size
        %                     as the image to be reconstructed (last column in gxH
        %                     is 0; last row in gyH is 0);
        %       PoissonOn = binary flag for Poisson solver during reconstruction (1 to
        %             include during reconstruction, 0 otherwise)
        %       meanval = scalar, equal to or an estimate of the mean value of the 2D image
        %       no_iter = number of iterations of Poisson solver
        % Output: R = reconstructed 2D image
        %
        % Example:
        %   I = double(imread('eight.tif'));
        %   [gxH,gyH] = getGradientH(I,1);
        %   meanval = mean(I(:));
        %   PoissonOn = 0;
        %   R = OneChannelRec(gxH,gyH,avg,meanval);
        %   figure, subplot(121),imshow(uint8(I)), title('original');
        %   subplot(122),imshow(uint8(R)), title('reconstruction');
        %
        % Written by: Ioana Sevcenco
        % Last updated: August 22, 2014
        if PoissonOn==0 && nargin < 5,
            no_iter = 0; % not used, but defined to avoid compiling errors
        end
        if PoissonOn==1 && nargin < 5,
            no_iter = 3; % suggested number of iterations
        end;
        no_rows_reconstruction = size(gxH,1);
        no_cols_reconstruction = size(gxH,2);
        [D,DX,DY] = GradientAnalysisH(gxH,gyH);
        R = GradientSynthesisH(D,DX,DY,PoissonOn,no_iter);
        R = R(1:no_rows_reconstruction,1:no_cols_reconstruction); % crop to desired value
        R = CorrectMeanValue(R,meanval);
    end

    function phase_next = PoissonSolveExtend(im,dPdx,dPdy)
        % extend phase by mirroring
        [dxH,dyH] = getGradientH(im);
        
        [m,n] = size(im);
        dpre = 4; % number of rows and cols we are extending by before the image (up and to the left);
        dpost = 2; % number of rows and cols we are extending by after (down and to the right);
        phase_ext = padarray(im,[dpre,dpre],'symmetric','pre'); % 4 rows and cols before
        phase_ext = padarray(phase_ext,[dpost,dpost],'symmetric','post'); % 2 rows and cols after
        
        m_ext = m + dpre + dpost;
        n_ext = n + dpre + dpost;
        
        dx_created = zeros(m_ext-1,n_ext-1);
        dx_created(dpre+1:end-dpost,dpre+1:end-dpost) = dPdx;
        dx_created(dpre,dpre+1:end-dpost) = dxH(1,:); % first row from dx
        dx_created(end-dpost+1,dpre+1:end-dpost) = dxH(end,:); % last row from dx
        dx_created(1:dpre-1,dpre+1:end-dpost) = flipud(dPdx(1:dpre-1,:));
        dx_created(end-dpost+2:end,dpre+1:end-dpost) = flipud(dPdx(end-dpost+2:end,:));
        dx_created(:,1:dpre-1) = -fliplr(dx_created(:,dpre+1:2*dpre-1));
        dx_created(:,end-dpost+2:end) = -fliplr(dx_created(:,end-dpost));
        
        dy_created = zeros(m_ext-1,n_ext-1);
        dy_created(dpre+1:end-dpost,dpre+1:end-dpost) = dPdy;
        dy_created(dpre+1:end-dpost,dpre) = dyH(:,1); % first column from dy
        dy_created(dpre+1:end-dpost,end-dpost+1) = dyH(:,end); % last column from dy
        dy_created(dpre+1:end-dpost,1:dpre-1) = fliplr(dPdy(:,1:dpre-1));
        dy_created(dpre+1:end-dpost,end-dpost+2:end) = fliplr(dPdy(:,end-dpost+2:end));
        dy_created(1:dpre-1,:) = -flipud(dy_created(dpre+1:2*dpre-1,:));
        dy_created(end-dpost+2:end,:) = -flipud(dy_created(end-dpost,:));
        
        div = getDiv(dx_created,dy_created);
        g = .25;
        lap = getLaplacian(phase_ext);
        phase_ext(2:end-1,2:end-1) = phase_ext(2:end-1,2:end-1) + g*(lap - div);
        phase_next = phase_ext(dpre+1:end-dpost,dpre+1:end-dpost);
    end

    function [dzdx dzdy] = Reflect(dzdx,dzdy)
        % program Reflect.m
        % Extends rectangular data to fill a square by reflecting the gradient data
        % Written by: Peter Hampton, Copyright August 2008
        %
        % Reference:
        % 1. P. Hampton, P. Agathoklis, C. Bradley, "Wavefront reconstruction
        % over a circular aperture using gradient data extrapolated via the
        % mirror equations", Applied Optics, 48(20):4018–4030, Jul. 2009
        %
        % Commented and updated by: Ioana Sevcenco, 2014
        %
        %  The truncation below is done to prevent using input data that is too high
        %  and could result in a software crash due to system memory limitations
        [row col] = size(dzdx);
        if row > 4095
            dzdx = dzdx(1:4095,:);
            dzdy = dzdy(1:4095,:);
        end
        if col > 4095
            dzdx = dzdx(:,1:4095);
            dzdy = dzdy(:,1:4095);
        end
        [row, col] = size(dzdx);
        M = ceil(log2(size(dzdx)+1));
        dzdx(row+1:2^M(1),:) = dzdx(row:-1:1+2*row-2^M(1),:);
        dzdx(:,col+1:2^M(2)) = -dzdx(:,col:-1:1+2*col-2^M(2));
        dzdy(row+1:2^M(1),:) = -dzdy(row:-1:1+2*row-2^M(1),:);
        dzdy(:,col+1:2^M(2)) = dzdy(:,col:-1:1+2*col-2^M(2));
        %only one of the following for loops will execute
        for k = M(1):M(2)-1
            dzdx(2^k+1:2^(k+1),:) = dzdx(2^k:-1:1,:);
            dzdy(2^k+1:2^(k+1),:) = -dzdy(2^k:-1:1,:);
        end
        for k = M(2):M(1)-1
            dzdx(:,2^k+1:2^(k+1)) = -dzdx(:,2^k:-1:1);
            dzdy(:,2^k+1:2^(k+1)) = dzdy(:,2^k:-1:1);
        end
    end

    function [dx_ext,dy_ext] = ReflectH( dxH,dyH )
        % program ReflectH.m
        % ==================
        % This program extends Hudgin gradient components to nearest power of two to
        % ensure zero curl condition (please see Sec.2.2 in Reference 1 for Hudgin
        % discretization equations).
        % Input gradients must be without row/ column of zeros
        % Inputs:
        %   dxH, dyH = Hudgin gradient horizontal and vertical components,
        %              respectively (without assumption of Neumann boundary
        %              conditions; forward difference)
        % Outputs:
        %   dx_ext, dy_ext = extended gradients to the nearest power of two
        %
        % Written by: Ioana Sevcenco, University of Victoria
        %
        % References:
        % 1. I. S. Sevcenco, P. Hampton, P. Agathoklis, "A wavelet based method
        % for image reconstruction from gradient data with applications",
        % Multidimensional Systems and Signal Processing, November 2013
        %
        % 2. P. Hampton, P. Agathoklis, "Comparison of Haar Wavelet-based and Poisson-based
        % Numerical Integration Techniques", 2010
        %
        % 3. P. Hampton, P. Agathoklis, C. Bradley, "A New Wave-Front Reconstruction
        % Method for Adaptive Optics Systems Using Wavelets", IEEE Journal of
        % Selected Topics in Signal Processing, vol. 2, no. 5, October 2008
        %
        %
        % Last Updated: August 21st, 2014
        given_rowx = size(dxH,1);
        given_colx = size(dxH,2);
        
        given_rowy = size(dyH,1);
        given_coly = size(dyH,2);
        
        s = max(given_rowx,given_coly);
        M = nextpow2(s);
        
        rowx = 2^M;
        colx = 2^M-1;
        
        rowy = 2^M-1;
        coly = 2^M;
        
        if (given_rowx~=rowx)||(given_rowy~=rowy)||(given_colx~=colx)||(given_coly~=coly),
            [dx_ext,dy_ext] = ReflectHC(dxH,dyH);
            
            new_rowx = size(dx_ext,1);
            new_colx = size(dx_ext,2);
            
            new_rowy = size(dy_ext,1);
            new_coly = size(dy_ext,2);
            
            while (new_rowx<rowx) || (new_rowy<rowy) || (new_colx<colx) || (new_coly<coly),
                if new_rowx>=rowx,
                    dx_ext = dx_ext(1:rowx,:);
                end;
                if new_colx>=colx,
                    dx_ext = dx_ext(:,1:colx);
                end;
                if new_rowy>=rowy,
                    dy_ext = dy_ext(1:rowy,:);
                end;
                if new_coly>=coly,
                    dy_ext = dy_ext(:,1:coly);
                end;
                [dx_ext,dy_ext] = ReflectHC(dx_ext,dy_ext);
                new_rowx = size(dx_ext,1);
                new_colx = size(dx_ext,2);
                new_rowy = size(dy_ext,1);
                new_coly = size(dy_ext,2);
            end
            if new_rowx>=rowx,
                dx_ext = dx_ext(1:rowx,:);
            end;
            if new_colx>=colx,
                dx_ext = dx_ext(:,1:colx);
            end;
            if new_rowy>=rowy,
                dy_ext = dy_ext(1:rowy,:);
            end;
            if new_coly>=coly,
                dy_ext = dy_ext(:,1:coly);
            end;
        else
            dx_ext = dxH; dy_ext = dyH;
        end
    end

    function [dzdx_ext,dzdy_ext] = ReflectHC(dzdx,dzdy)
        [rowx, colx] = size(dzdx);
        dzdx_ext(1:rowx,1:colx) = dzdx;
        
        dzdx_ext(rowx+1:2*rowx-1,1:colx) = flipud(dzdx_ext(1:rowx-1,:)); % fill downwards first
        dzdx_ext = [dzdx_ext -fliplr(dzdx_ext)];
        
        [rowy, coly] = size(dzdy);
        dzdy_ext(1:rowy,1:coly) = dzdy;
        
        dzdy_ext(rowy+1:2*rowy,1:coly) = -flipud(dzdy_ext(1:rowy,1:coly)); % fill downwards first
        dzdy_ext = [dzdy_ext fliplr(dzdy_ext(:,1:end-1))];
    end



    function [R,G,B,mr,mg,mb] = splitRGB(I,display_channels)
        % Program splitRGB.m
        % Given a multichannel image, this function separates it in its R, G and B channels
        % and returns each matrix as an output, and the mean value in each channel.
        %
        % Inputs:
        %   I = color image
        %   display_channels = optional input; should be set to 1 if we want to
        %                      see each channel
        %
        % Outputs:
        %   R, G, B = the three channels
        %   mr, mg, mb = the mean value in each channel
        %
        % Example:
        %   I = double(imread('peppers.png'));
        %   [R,G,B,mr,mg,mb] = splitRGB(I,1);
        if nargin<2
            display_channels = 0;
        end
        R = I(:,:,1);
        mr = mean(R(:));
        
        G = I(:,:,2);
        mg = mean(G(:));
        
        B = I(:,:,3);
        mb = mean(B(:));
        
        if display_channels
            % Clear the other color channels and display channels individually
            R_disp = zeros(size(I));
            R_disp(:,:,1) = R;
            
            G_disp = zeros(size(I));
            G_disp(:,:,2) = G;
            
            B_disp = zeros(size(I));
            B_disp(:,:,3) = B;
            
            figure;
            subplot(131); imshow(uint8(R_disp)); title('Red channel');
            subplot(132); imshow(uint8(G_disp)); title('Green channel');
            subplot(133); imshow(uint8(B_disp)); title('Blue channel');
        end
    end

end