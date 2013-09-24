--xmonad.hs

import Prelude as P
import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Config.Xfce
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimpleFloat
import XMonad.Layout.ResizableTile
import XMonad.Hooks.DynamicLog
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CopyWindow
import XMonad.StackSet as W
import Data.List.Split as S
import Data.List

--------------------------------------------------------------------------------

-- Commands and configuration for dzen bar and other spawned processes.
dzenCmd = ("dzen2 -h '18' -bg '#000000' -fg '#ffffff' -fn 'Ubuntu Mono-12:Regular' " ++)
statBarCmd0 = dzenCmd "-ta 'l' -x '0' -w '1440'"
statBarCmd1 = dzenCmd "-ta 'l' -x '1920' -w '960'"
statBarCmd2 = dzenCmd "-ta 'l' -x '4480' -w '960'"

pandoraCmd  = "ruby ~/.xmonad/dzen-pandora/dzen-pandora.rb | "
              ++ dzenCmd "-ta 'r' -x '2880' -w '1600'"

conkyCmd = "conky | " ++ dzenCmd "-ta 'r' -x '5440' -w '960'"

-- Specifies the physical order of monitors indexed by xinerama.
screenOrder = [2,1,0]

--------------------------------------------------------------------------------

main = do

    statBar0 <- spawnPipe statBarCmd0
    statBar1 <- spawnPipe statBarCmd1
    statBar2 <- spawnPipe statBarCmd2

    _ <- spawn pandoraCmd
    _ <- spawn conkyCmd

    xmonad . ewmh $ xfceConfig
            {
              XMonad.workspaces = (map show [1..9]),
              normalBorderColor = "#000000",
              focusedBorderColor = "#cb4b16",
              modMask = mod4Mask,
              terminal = "terminator",
              focusFollowsMouse = False,
              borderWidth = 2,
              layoutHook = layoutHook',
              manageHook = manageHook',
              logHook = logHook' statBar0 statBar1 statBar2
            } `additionalKeysP` myKeys

--------------------------------------------------------------------------------

myKeys =
    [
     -- check if unsafeSpawn can call standard 'shoot' script
        ("M-x", spawn "xfce4-screenshooter -r -o /home/jaburns/tools/imgur-upload"),
        ("M-p", spawn "dmenu_run -nb black -nf white"),
        ("M-S-h", sendMessage MirrorShrink),
        ("M-S-l", sendMessage MirrorExpand),
        ("M-r", spawn "xmonad --restart")
    ]
    ++ -- Map M-"qwe" to select a monitor in the proper order, and use M-r for restarting xmonad.
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "qwe" screenOrder
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ] ]

--------------------------------------------------------------------------------

layoutHook' = border1 (ResizableTall 1 (3/100) (1/2) [])
          ||| border2 (ThreeColMid   1 (3/100) (1/2))
          ||| noBorders Full
  where
    border1 = avoidStruts . smartBorders . spacing 4
    border2 = avoidStruts . smartBorders . spacing 2

 {-onWorkspace "4" (noBorders Full) $
              onWorkspace "5" simpleFloat $

              (Resijjj
  where
    layouts =
              (layoutHook defaultConfig) ||| -}

--------------------------------------------------------------------------------

manageHook' = fixNotify <+> manageHook xfceConfig
  where
    fixNotify = composeAll [ className =? "xfce4-notifyd" --> doIgnore ]

--------------------------------------------------------------------------------

logHook' h0 h1 h2 = dynamicLogWithPP $ defaultPP
    {
      ppCurrent = wrap "c" ","
    , ppVisible = wrap "v" ","
    , ppHidden  = wrap "h" ","
    , ppUrgent  = wrap "u" ","
    , ppSort    = getSortByXineramaRule
    , ppLayout  = const ""
    , ppOutput  = \s -> do hPutStrLn h0 (dzenWriter 0 s)
                           hPutStrLn h1 (dzenWriter 1 s)
                           hPutStrLn h2 (dzenWriter 2 s)
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


parsePPStats :: String -> WSStatus
parsePPStats inp = WSStatus
    {
      wsCurrent  = getNum . head . P.filter (hasTag 'c') $ inpVals
    , wsVisibles = reorderBy screenOrder . map getNum . take (length screenOrder) $ inpVals
    , wsHiddens  = map getNum . P.filter (hasTag 'h') $ inpVals
    , wsUrgents  = map getNum . P.filter (hasTag 'u') $ inpVals
    }
  where
    inpVals = P.filter (not . null) . splitOn ", " $ inp
    hasTag c cs = head cs == c
    getNum = read . tail


dzenWriter :: Int -> String -> String
dzenWriter monitor pp =
    concatMap render [1..9] ++ " : " ++ title
  where
    wsStats = parsePPStats . head . splitOn ":" $ pp
    title   = concat . tail . splitOn ":" $ pp

    render n
      | n == wsVisibles wsStats !! monitor =
        "^fg(black)^bg(white)" ++ pad (show n) ++ "^fg()^bg()"

      | n `elem` wsVisibles wsStats || n `elem` wsHiddens wsStats =
        "^fg()^bg(#444444)" ++ pad (show n) ++ "^fg()^bg()"

      | n `elem` wsUrgents wsStats =
        "^fg(red)" ++ pad (show n) ++ "^fg()"

      | otherwise = pad . show $ n

