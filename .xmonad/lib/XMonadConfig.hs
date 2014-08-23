
module XMonadConfig (mainAction, Machine(..)) where

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
import XMonad.Layout.Reflect
import XMonad.Hooks.DynamicLog
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CopyWindow
import XMonad.StackSet as W
import Data.List.Split as S
import Data.List

import CustomLog (customLogHook)

data Machine = Desktop | Laptop

--------------------------------------------------------------------------------

-- Commands and configuration for dzen bar and other spawned processes.
dzenCmd fnt = (++) $ "dzen2 -h '24' -bg '#000000' -fg '#ffffff' -fn '"++fnt++"' "

dzenSans = dzenCmd "Ubuntu Sans-10:Regular"
dzenMono = dzenCmd "Ubuntu Mono-12:Regular"

-- Specifies the physical order of monitors indexed by xinerama.
desktopScreenOrder = [0,1]

--------------------------------------------------------------------------------

laptop :: IO (X ())
laptop = do

    statBar <- spawnPipe $ dzenSans "-ta 'l' -x '0' -y '1056' -w '1440'"   --1920x1080
                                 -- "-ta 'l' -x '0' -y '1176' -w '1440'"   --1920x1200
    _ <- spawn "feh --bg-scale ~/Pictures/outer-space-HD-Wallpapers.jpg"
    return $ customLogHook [statBar] [0]


desktop :: IO (X ())
desktop = do
    _ <- spawn $ "xrandr --output DVI-I-1 --mode 2560x1440 --primary "
                     ++ "--output DVI-D-0 --mode 1920x1080 --pos 2560x360"

    statBar0 <- spawnPipe $ dzenSans "-ta 'l' -x '0' -y '0' -w '1280'"
    statBar1 <- spawnPipe $ dzenSans "-ta 'l' -x '2560' -y '360' -w '960'"

    _ <- spawn $ "ruby ~/dotfiles/tools/dzen-pandora/dzen-pandora.rb | "
                    ++ dzenSans "-ta 'r' -x '1280' -y '0' -w '640'"

    _ <- spawn $ "conky | " ++ dzenMono "-ta 'r' -x '3520' -y '360' -w '576'"

    return $ customLogHook [statBar0,statBar1] desktopScreenOrder


mainAction :: Machine -> IO ()
mainAction machine = do

    logHook' <- case machine of
        Laptop -> laptop
        Desktop -> desktop


    xmonad . ewmh $ xfceConfig
            {
              XMonad.workspaces = (map show [1..9]),
              normalBorderColor = "#000000",
              focusedBorderColor = "#cb4b16",
              --modMask = mod4Mask,
              terminal = "xfce4-terminal",
              focusFollowsMouse = False,
              borderWidth = 2,
              layoutHook = layoutHook',
              manageHook = manageHook',
              logHook = logHook'
            } `additionalKeysP` myKeys

--------------------------------------------------------------------------------

myKeys =
    [
     -- check if unsafeSpawn can call standard 'shoot' script
        ("M-p", spawn "dmenu_run -fn r24 -nb black -nf white"),
        ("M-S-h", sendMessage MirrorShrink),
        ("M-S-l", sendMessage MirrorExpand),
        ("M-r", spawn "xmonad --recompile && xmonad --restart")
    ]
    ++ -- Map M-"qwe" to select a monitor in the proper order, and use M-r for restarting xmonad.
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "qwe" desktopScreenOrder
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ] ]

--------------------------------------------------------------------------------

layoutHook' = border1 (ResizableTall 1 (3/100) (1/2) [])
          ||| reflectHoriz (border1 (ResizableTall 1 (3/100) (1/2) []))
          ||| border2 (ThreeCol 1 (3/100) (1/2))
          ||| reflectHoriz (border2 (ThreeCol 1 (3/100) (1/2)))
          ||| noBorders Full
  where
    border1 = avoidStruts . smartBorders . spacing 4
    border2 = avoidStruts . smartBorders . spacing 2

--------------------------------------------------------------------------------

manageHook' = fixNotify <+> manageHook xfceConfig
  where
    fixNotify = composeAll [ className =? "Xfce4-notifyd" --> doIgnore ]


