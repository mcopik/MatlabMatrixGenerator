classdef Random < MatrixGenerator.Properties.PropertyType
    
    properties
        Boundaries
    end
    
    methods
        
        function obj = Random(varargin)
            if isempty(varargin)
                obj.Boundaries = [-1 1];
            elseif length(varargin) == 1 && length(varargin{1}) == 2
                obj.Boundaries = varargin{1}; 
            else
                error('Incorrect settings for Random property');
            end
        end
        
        function [matrix] = generate(obj, size, type, varargin)
            
            boundaries = obj.Boundaries;
            for i = 1:length(varargin)
                if isa(varargin{i}, 'MatrixGenerator.Properties.Positive')
                    boundaries = [0 obj.Boundaries(2)];
                elseif isa(varargin{i}, 'MatrixGenerator.Properties.Negative')
                    boundaries = [obj.Boundaries(1) 0];
                end
            end
            
            if isa(type, 'MatrixGenerator.Shapes.General')
                matrix = random_general(boundaries, size);
            elseif isa(type, 'MatrixGenerator.Shapes.Symmetric')
                matrix = random_symmetric(boundaries, size);
            elseif isa(type, 'MatrixGenerator.Shapes.UpperTriangular')
                matrix = random_triangular(boundaries, size, 'U');
            elseif isa(type, 'MatrixGenerator.Shapes.LowerTriangular')
                matrix = random_triangular(boundaries, size, 'L');
            elseif isa(type, 'MatrixGenerator.Shapes.Diagonal')
                matrix = random_diagonal(boundaries, size);
            else
                error('Unknown matrix type');
            end
        end
        
    end
    
end

function [matrix] = random_general(boundaries, size)
    matrix = boundaries(1) + (boundaries(2) - boundaries(1))*rand(size);
end

function [matrix] = random_symmetric(boundaries, size)
    matrix = random_general(boundaries, size);
    matrix = matrix + matrix';
end

function [matrix] = random_triangular(boundaries, size, uplo)
    matrix = random_general(boundaries, size);
    if uplo == 'U'
        matrix = triu(matrix);
    else
        matrix = tril(matrix);
    end
end

function [matrix] = random_diagonal(boundaries, matrix_size)
    diag_size = min(matrix_size(1), matrix_size(2));
    matrix = diag( boundaries(1) + (boundaries(2) - boundaries(1))*rand(diag_size, 1) );
    if matrix_size(1) > matrix_size(2)
        matrix = [matrix; zeros(matrix_size(1) - diag_size, matrix_size(2))];
    elseif matrix_size(1) < matrix_size(2)
        matrix = [matrix zeros(diag_size, matrix_size(2) - diag_size)];
    end
end
