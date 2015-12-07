import Data.List
import Data.List.Split

main = do
    all_problems <- readFile "input.txt"
    let paper = sum $ map problem_paper $ lines all_problems
    let ribbon = sum $ map problem_ribbon $ lines all_problems
    putStrLn $ "We require " ++ show paper ++ " square feet of paper"
    putStrLn $ "and " ++ show ribbon ++ " feet of ribbon"

problem_paper :: String -> Int
problem_paper = paper . split_in

problem_ribbon :: String -> Int
problem_ribbon = ribbon . split_in

split_in :: String -> [Int]
split_in = (map read) .  (splitOn "x")

paper :: [Int] -> Int
paper xs = area xs + smallest_square xs

area :: [Int] -> Int
area [x,y,z] = 2*x*y + 2*x*z + 2*y*z

smallest_square :: [Int] -> Int
smallest_square = (product . take 2 . sort)

ribbon :: [Int] -> Int
ribbon xs = volume xs + smallest_perimeter xs

volume :: [Int] -> Int
volume = product

smallest_perimeter :: [Int] -> Int
smallest_perimeter xs = 2 * (sum $ take 2 $ sort xs)