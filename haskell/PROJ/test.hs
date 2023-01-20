import Proj
test :: IO()
test = do 

    -- Sum Tests

    putStr "\nSum: 2x^2y + 2x AND 2yx^2 + 3x\n"
    putStr "Expected: 4x^2y + 5x\nGot: "
    putStr (addInput "2x^2y + 2x" "2yx^2 + 3x")
    putStr " \n\n"


    putStr "\nSum: 2x^2 + 2x + 2 AND 2y^2 + x^2 + 3x - 1\n"
    putStr "Expected: 3x^2 + 5x + 2y^2 + 1 \nGot: "
    putStr (addInput "2x^2 + 2x + 2" "2y^2 + x^2 + 3x - 1")
    putStr " \n\n"


    putStr "\nSum: 5x + 3y + 4x - 4y + z AND -3x + 5y + 2z\n"
    putStr "Expected: 6x + 4y + 3z\nGot: "
    putStr (addInput "5x + 3y + 4x - 4y + z" "-3x + 5y + 2z")
    putStr " \n\n"

    putStr "Sum: 5x + 3y + 4x - 4y + z AND -3x + 5y + 2z\n"
    putStr "Expected: 5a^2 - 7ab + 6b^2\nGot: "
    putStr (addInput "3a^2 + ab - b^2 - a^2 + 2ab + 3b^2" "3a^2 - 10ab + 4b^2")
    putStr " \n\n"

    putStr "Sum: 5x + 3y + 4x - 4y + z AND -3x + 5y + 2z\n"
    putStr "Expected: 10x^3 + 6x^2 - 9x + 2\nGot: "
    putStr (addInput "3x^3 - 5x^2 + 8x + 10 + 15x^3 - 6x - 23 + 9x^2 - 4x + 15" "-8x^3 + 2x^2 - 7x")
    putStr " \n\n"


    -- Multiply Tests

    putStr "----------------------------------------\n"
    putStr "\nMultiply: 2x^2 + 2 AND x + 5 \n"
    putStr "Expected: 10x^2 + 2x^3 + 2x + 10\nGot: "
    putStr (multiInput "2x^2 + 2" "x + 5")
    putStr " \n\n"

    putStr "\nMultiply: 5xy + 2x + y AND 5yx + 2 \n"
    putStr "Expected: 25x^2y^2 + 10x^2y + 5xy^2 + 10xy + 4x + 2y\nGot: "
    putStr (multiInput "5xy + 2x + y" "5yx + 2")
    putStr " \n\n"

    putStr "\nMultiply: 8x^3y^2 AND 6x^2 + 3x^2y + 4y^2\n"
    putStr "Expected: 48x^5y^2 + 24x^5y^3 + 32x^3y^4\nGot: "
    putStr (multiInput "8x^3y^2" "6x^2 + 3x^2y + 4y^2")
    putStr " \n\n"

    putStr "\nMultiply: 5 + 0x^1 + 10x^2 + 6x^3 AND 1 + 2x^1 + 4x^2\n"
    putStr "Expected: 5 + 10x + 30x^2 + 26x^3 + 52x^4 + 24x^5\nGot: "
    putStr (multiInput "5 + 0x^1 + 10x^2 + 6x^3" "1 + 2x^1 + 4x^2")
    putStr " \n\n"


    -- Derivation Tests
    putStr "----------------------------------------\n"
    putStr "\nDerivation: 2x^2 + 2\n"
    putStr "Expected: 4x\nGot: "
    putStr (deriveInput "2x^2 + 2" "x")
    putStr " \n\n"

    putStr "\nDerivation: 2x^5 + 2x^6 + 2xy - 4y + x\n"
    putStr "Expected: 10x^4 + 12x^5 + 2y + 1\nGot: "
    putStr (deriveInput "2x^5 + 2x^6 + 2xy - 4y + x" "x")
    putStr " \n\n"

    putStr "\nDerivation: 2x^5y + 2x^6 + 2xy - 4y + x\n"
    putStr "Expected: 2x^5 - 4 + 2x\nGot: "
    putStr (deriveInput "2x^5y + 2x^6 + 2xy - 4y + x" "y")
    putStr " \n\n"

    -- Normalize
    putStr "----------------------------------------\n"
    putStr "\nNormalize: 2x^2 + x^2 + 5 - 2x + 5x - 4\n"
    putStr "Expected: 3x^2 + 3x + 1\nGot: "
    putStr (normalizeInput "2x^2 + x^2 + 5 - 2x + 5x - 4")
    putStr " \n\n"

    putStr "----------------------------------------\n"
    putStr "\nNormalize: 2x^2y + 2yx^2 + 4x - 2x + 5y - y^2 + y\n"
    putStr "Expected: 4x^2y + 2x + 6y - y^2\nGot: "
    putStr (normalizeInput "2x^2y + 2yx^2 + 4x - 2x + 5y - y^2 + y")
    putStr " \n\n"

    putStr "----------------------------------------\n"
    putStr "\nNormalize: 2x^2 + x^2 + 5 - 2x + 5x - 4\n"
    putStr "Expected: 3x^2 + 3x + 1\nGot: "
    putStr (normalizeInput "2x^2 + x^2 + 5 - 2x + 5x - 4")
    putStr " \n\n"


   