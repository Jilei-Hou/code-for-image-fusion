function norm_SIFTFeatureVector = DSIFTNormalization(SIFTFeatureVector)
%Function for dense SIFT normalization. Please note that this function is
%edited based on C. Liu's code, which is available on http://people.csail.mit.edu/celiu/ECCV2008/

[ nrows, ncols, dimension ] = size( SIFTFeatureVector );

% normalize SIFT descriptors
norm_SIFTFeatureVector = reshape( SIFTFeatureVector, [nrows * ncols dimension ] );
norm_SIFTFeatureVector = SIFTNormalization( norm_SIFTFeatureVector );
norm_SIFTFeatureVector = reshape( norm_SIFTFeatureVector, [ nrows ncols dimension]  );


function SIFTFeatureVector = SIFTNormalization( SIFTFeatureVector )
% normalize SIFT descriptors (after Lowe)

% find indices of descriptors to be normalized (those whose norm is larger than 1)
tmp = sqrt( sum( SIFTFeatureVector.^2, 2 ) );
normalizeIndex = find( tmp > 1 );

SiftFeatureVectorNormed = SIFTFeatureVector( normalizeIndex, : );
SiftFeatureVectorNormed = SiftFeatureVectorNormed ./ repmat( tmp( normalizeIndex, : ), [ 1 size( SIFTFeatureVector, 2 ) ] );

% suppress large gradients
SiftFeatureVectorNormed( SiftFeatureVectorNormed > 0.2 ) = 0.2;

% finally, renormalize to unit length
tmp = sqrt( sum( SiftFeatureVectorNormed.^2, 2 ) );
SiftFeatureVectorNormed = SiftFeatureVectorNormed ./ repmat( tmp, [ 1 size( SIFTFeatureVector, 2 ) ] );

SIFTFeatureVector( normalizeIndex, : ) = SiftFeatureVectorNormed;