{-

NOTE: This is my first Haskell problem, so it's slow and probable looks bad.

-}
import Data.Map as Map (insert, empty, lookup, toList, insertWith, Map)
import System.IO (openFile, IOMode(ReadMode), hGetContents)
import System.Environment (getArgs)
import Data.List (intercalate)
import Text.Printf (printf)

type Vector = (Double,Double,Double)
type Face = (Int,Int,Int)

-- For testing.
faces = [(0,1,2),(1,2,3)]
vertices = [
  (0,0,0)::Vector,
  (1,0,0)::Vector,
  (0,1,0)::Vector,
  (0,0,1)::Vector]

{-
---- Vector ops ----
-}
cross :: Vector -> Vector -> Vector
cross (a0,a1,a2) (b0,b1,b2) = (a1*b2 - a2*b1, a2*b0-a0*b2, a0*b1 - a1*b0)

vector_length :: Vector -> Double
vector_length (a0,a1,a2) = sqrt $ a0*a0 + a1*a1 + a2*a2

vector_scale :: Double -> Vector -> Vector
vector_scale s (a0,a1,a2) = (a0*s, a1*s, a2*s)

vector_unitize :: Vector -> Maybe Vector
vector_unitize v = let len = vector_length v in if len == 0 then Nothing else Just (vector_scale (1 / len) v)
      
vector_sub :: Vector -> Vector -> Vector
vector_sub (a0,a1,a2) (b0,b1,b2) = (a0-b0, a1-b1, a2-b2)

vector_add :: Vector -> Vector -> Vector
vector_add (a0,a1,a2) (b0,b1,b2) = (a0+b0, a1+b1, a2+b2)

vector_sum :: [Vector] -> Vector
vector_sum = foldl vector_add ((0,0,0)::Vector)

{-
---- Utils ----
-}

enumerate :: Int -> [a] -> [(Int, a)]
enumerate _ [] = []
enumerate n (a:rest) = (n,a):(enumerate (n+1) rest)

-- Extract vectors from face.
extract_vectors :: Map Int Vector -> Face -> Maybe (Vector,Vector,Vector)
extract_vectors vsm f = extract_vectors' $ (Map.lookup a vsm, Map.lookup b vsm, Map.lookup c vsm)
  where (a,b,c) = f

extract_vectors' :: (Maybe Vector, Maybe Vector, Maybe Vector) -> Maybe (Vector, Vector, Vector)
extract_vectors' (Just a, Just b, Just c) = Just (a,b,c)
extract_vectors' (_,_,_) = Nothing

list_to_map :: Int -> [a] -> Map Int a
list_to_map _ [] = Map.empty
list_to_map n (v:rest) = Map.insert n v $ list_to_map (n+1) rest

{-
---- Face ops ----
-}
face_normal :: Map Int Vector -> Face -> Maybe Vector
face_normal vsm f = (extract_vectors vsm f) >>= \(v0,v1,v2) -> (vector_unitize $ cross (vector_sub v1 v0) (vector_sub v2 v0))
  
face_normals :: Map Int Vector -> [Face] -> (Maybe [Vector])
face_normals vsm fs = sequence $ [face_normal vsm f | f <- fs]

vector_faces :: [Vector] -> [(int, Face)] -> [[int]]
vector_faces vs fse = [v | (_,v) <- Map.toList (vector_faces' vs fse)]
vector_faces' _ [] = Map.empty
vector_faces' vs ((n,(a, b, c)):efs) = foldr (\x m -> Map.insertWith (\a b -> a ++ b) x [n] m) (vector_faces' vs efs) [a,b,c]

vector_make_normals :: Map Int Vector -> [Int] -> Maybe [Vector]
vector_make_normals face_normals_ faces = sequence $ map (\i -> Map.lookup i face_normals_) faces

vectors_normals :: [[Int]] -> Map Int Vector -> Maybe [[Vector]]
vectors_normals faces face_normals_ = sequence $ map (vector_make_normals face_normals_) faces

vectors_normal :: [Vector] -> [Face] -> Maybe [Vector]
vectors_normal vs fs = face_normals vsm fs >>= \face_normals_ -> vectors_normals faces (list_to_map 0 face_normals_) >>= \x -> Just (map vector_sum x) >>= \x -> sequence (map vector_unitize x)
  where vsm = list_to_map 0 vs
        fsm = list_to_map 0 fs
        fse = enumerate 0 fs
        faces = vector_faces vs $ fse
  
{-
--------- Parsing --------
-}
-- Curiously this is as fast as Data.List.Split.splitOn.
split :: Char -> String -> [String]
split _ "" = []
split c s = word:(split c rest)
  where word = takeWhile (/= c) s
        rest = drop (length word+1) s

trim :: Char -> String -> String
trim c = (rtrim c) . ltrim c

ltrim :: Char -> String -> String
ltrim c = dropWhile (== c)

rtrim :: Char -> String -> String
rtrim c s = reverse $ ltrim c $ reverse s

atof' :: String -> (Double, String)
atof' s = r
  where r:_ = y
        y =  reads s :: [(Double, String)]

atoi' :: String -> (Int, String)
atoi' s = r
  where r:_ = y
        y =  reads s :: [(Int, String)]

atoi :: String -> Maybe Int
atoi = ato atoi'

atof :: String -> Maybe Double
atof = ato atof'

ato :: (String -> (a, String)) -> String -> Maybe a
ato f s = case (f s) of (v, "")   -> Just v
                        otherwise -> Nothing
                        
processLine :: (String -> Maybe a) -> String -> Maybe [a]
processLine conv s = sequence $ map conv $ map (trim ' ') $ split ',' s

list2vec :: [Double] -> Maybe Vector
list2vec [x,y,z] = Just (x,y,z)
list2vec _ = Nothing

list2face :: [Int] -> Maybe Face
list2face [x,y,z] = Just (x,y,z)
list2face _ = Nothing

parseSomething :: (String -> Maybe a) -> ([a] -> Maybe b) -> String -> Maybe [b]
parseSomething atox conv contents = sequence $ map (conv =<<) $ map (processLine atox) lines
  where lines = map (ltrim '<') $ map (rtrim '>') $ map (rtrim ',') $ split '\n' contents

-- parseVectors adds an extra vector to the beginning because the input is one-based.
parseVectors :: String -> Maybe [Vector]
parseVectors s = fmap (\x -> ((0,0,0)::Vector):x) $ parseSomething atof list2vec s

parseFaces :: String -> Maybe [Face]
parseFaces = parseSomething atoi list2face

{-
------ High level functions & formatting ------
-}
gen_normals :: String -> String -> Maybe [Vector]
gen_normals vc fc = parseVectors vc >>= \vs -> parseFaces fc >>= \fs -> vectors_normal vs fs

formatLine :: Vector -> String
formatLine (a,b,c) = printf "<%f,%f,%f>," a b c

formatOutput :: [Vector] -> String
formatOutput v = intercalate "\n" $ (map formatLine v)

generate_output :: String -> String -> Maybe String
generate_output vc fc = gen_normals vc fc >>= \normals -> Just $ formatOutput normals

main :: IO ()
main = do
  (vfn:ffn:fon:_) <- getArgs
  vh <- openFile vfn ReadMode
  fh <- openFile ffn ReadMode
  vc <- hGetContents vh
  fc <- hGetContents fh
  let ns = generate_output vc fc
  mapM_ (writeFile fon) ns
