
module CustomLog (customLogHook) where


import XMonad
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Util.WorkspaceCompare
import Data.List
import Data.List.Split


customLogHook handles screenOrder = dynamicLogWithPP $ defaultPP
    {
      ppCurrent = wrap "c" ","
    , ppVisible = wrap "v" ","
    , ppHidden  = wrap "h" ","
    , ppUrgent  = wrap "u" ","
    , ppSort    = getSortByXineramaRule
    , ppLayout  = const ""
    , ppOutput  = \s -> mapM_ (\(h,i) -> hPutStrLn h $ dzenWriter screenOrder s i) $
                        handles `zip` [0..]
    }


data WSStatus = WSStatus
    {
      wsCurrent  :: Int   -- The current active workspace
    , wsVisibles :: [Int] -- All visible workspaces indexed by monitor
    , wsHiddens  :: [Int] -- All hidden workspaces with windows
    , wsUrgents  :: [Int] -- All hidden workspaces marked as urgent
    }


reorderBy :: Ord o => [o] -> [a] -> [a]
reorderBy indices xs = map snd . sortByFst . zip indices $ xs
  where
    sortByFst = sortBy (\(x,_) (y,_) -> x `compare` y)


parsePPStats :: Ord o => [o] -> String -> WSStatus
parsePPStats scOrd inp = WSStatus
    {
      wsCurrent  = getNum . head . filter (hasTag 'c') $ inpVals
    , wsVisibles = reorderBy scOrd . map getNum . take (length scOrd) $ inpVals
    , wsHiddens  = map getNum . filter (hasTag 'h') $ inpVals
    , wsUrgents  = map getNum . filter (hasTag 'u') $ inpVals
    }
  where
    inpVals = filter (not . null) . splitOn ", " $ inp
    hasTag c cs = head cs == c
    getNum = read . tail


dzenWriter :: Ord o => [o] -> String -> Int -> String
dzenWriter scOrd pp monitor =
    concatMap render [1..9] ++ " : " ++ title
  where
    wsStats = parsePPStats scOrd . head . splitOn ":" $ pp
    title   = concat . tail . splitOn ":" $ pp

    render n
      | n == wsVisibles wsStats !! monitor =
        "^fg(black)^bg(white)" ++ pad (show n) ++ "^fg()^bg()"

      | n `elem` wsVisibles wsStats || n `elem` wsHiddens wsStats =
        "^fg()^bg(#444444)" ++ pad (show n) ++ "^fg()^bg()"

      | n `elem` wsUrgents wsStats =
        "^fg(red)" ++ pad (show n) ++ "^fg()"

      | otherwise = pad . show $ n

