
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

statBarCmdLaptop = dzenSans "-ta 'l' -x '0' -y '1056' -w '1440'"

statBarCmd0 = dzenSans "-ta 'l' -x '0' -y '360' -w '1440'"
statBarCmd1 = dzenSans "-ta 'l' -x '1920' -w '960'"
statBarCmd2 = dzenSans "-ta 'l' -x '4480' -w '1280'"

pandoraCmd  = "ruby ~/.xmonad/dzen-pandora/dzen-pandora.rb | "
              ++ dzenSans "-ta 'r' -x '2880' -w '1600'"

conkyCmd = "conky | " ++ dzenMono "-ta 'r' -x '5760' -w '1280'"

-- Specifies the physical order of monitors indexed by xinerama.
desktopScreenOrder = [1,2,0]

--------------------------------------------------------------------------------

laptop :: IO (X ())
laptop = do
    statBar <- spawnPipe statBarCmdLaptop
    return $ customLogHook [statBar] [0]


desktop :: IO (X ())
desktop = do

    statBar0 <- spawnPipe statBarCmd0
    statBar1 <- spawnPipe statBarCmd1
    statBar2 <- spawnPipe statBarCmd2

    _ <- spawn pandoraCmd
    _ <- spawn conkyCmd

    return $ customLogHook [statBar0,statBar1,statBar2] desktopScreenOrder


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
        ("M-x", spawn "xfce4-screenshooter -r -o /home/jaburns/tools/imgur-upload"),
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
          ||| border2 (ThreeColMid   1 (3/100) (1/2))
          ||| noBorders Full
  where
    border1 = avoidStruts . smartBorders . spacing 4
    border2 = avoidStruts . smartBorders . spacing 2

--------------------------------------------------------------------------------

manageHook' = fixNotify <+> manageHook xfceConfig
  where
    fixNotify = composeAll [ className =? "xfce4-notifyd" --> doIgnore ]


