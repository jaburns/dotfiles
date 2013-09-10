import Prelude as P
import XMonad
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Config.Xfce
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CopyWindow
import XMonad.StackSet as W
import Data.List.Split as S


-- This hook returns focus to its original window after an xfce notification pops up.
notificationFocus :: ManageHook
notificationFocus = composeAll [
    className =? "xfce4-notifyd" --> doF W.focusDown <+> doF copyToAll ]


-- Commands and configuration for dzen bar.
dzenCmd = ("dzen2 -h '18' -fg '#ffffff' -fn 'Ubuntu Sans-9:Regular' " ++)
statBarCmd0 = dzenCmd "-ta 'l' -x '0' -w '1440'"
statBarCmd1 = dzenCmd "-ta 'l' -x '1920' -w '960'"
pandoraCmd  = "ruby ~/.xmonad/dzen-pandora/dzen-pandora.rb | "
              ++ dzenCmd "-ta 'r' -x '2880' -w '960'"


screenOrder = [1,0]


main = do

    statBar0 <- spawnPipe statBarCmd0
    statBar1 <- spawnPipe statBarCmd1

    _ <- spawn pandoraCmd

    xmonad . ewmh $ xfceConfig
            {
              normalBorderColor = "#000000",
              focusedBorderColor = "#cb4b16",
              focusFollowsMouse = False,
              borderWidth = 2,
              layoutHook = layoutHook',
              manageHook = notificationFocus <+> manageHook xfceConfig,
              logHook = logHook' statBar0 statBar1
            } `additionalKeysP` myKeys

-- Map M-"qwe" to select a monitor in the proper order, and use M-r for restarting xmonad.
myKeys =
    [
        ("M-r", spawn "xmonad --restart")
    ]
    ++
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "qwe" screenOrder
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ] ]


layoutHook' = avoidStruts . smartBorders . spacing 5 $ (layoutHook xfceConfig)




logHook' h0 h1 = dynamicLogWithPP $ defaultPP
    {
      ppCurrent = wrap "c" ","
    , ppVisible = wrap "v" ","
    , ppHidden  = wrap "h" ","
    , ppUrgent  = wrap "u" ","
    , ppSort    = getSortByXineramaRule
    , ppLayout  = \y -> ""
    , ppOutput  = \s -> do hPutStrLn h0 (dzenWriter 0 s)
                           hPutStrLn h1 (dzenWriter 1 s)
    }


data WSStatus = WSStatus
    {
      wsCurrent  :: Int   -- The current active workspace
    , wsVisibles :: [Int] -- All visible workspaces indexed by monitor
    , wsHiddens  :: [Int] -- All hidden workspaces with windows
    , wsUrgents  :: [Int] -- All hidden workspaces marked as urgent
    }


parsePPStats :: String -> WSStatus
parsePPStats inp = WSStatus
    {
      wsCurrent  = getNum . head . P.filter (hasTag 'c') $ inpVals
          -- Reverse here should use proper screenOrder (zip with screen order and sort)
    , wsVisibles = reverse . map getNum . take (length screenOrder) $ inpVals
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
        "^fg(green)" ++ pad (show n) ++ "^fg()"

      | n `elem` wsUrgents wsStats =
        "^fg(red)" ++ pad (show n) ++ "^fg()"

      | otherwise = pad . show $ n
