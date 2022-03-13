function [ PyrDef ] = Pyramid(Level, type)
% This function gives a definition of the data contained in the pyramid according its type and height (level).
    switch(type)
        case 'Laplacian'
            PyrDef=struct('G', {cell(1, Level)}, 'L', {cell(1, Level)});
        case 'Gaussian'
            PyrDef=struct('G', {cell(1, Level)});
        otherwise
            error(['The type ', type, ' is unknown']);
    end
end
