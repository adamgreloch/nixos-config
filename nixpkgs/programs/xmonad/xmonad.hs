{-# LANGUAGE RecordWildCards, DeriveDataTypeable, TypeSynonymInstances, MultiParamTypeClasses #-}

{-
 - TODO:
 - [X] Fix xmobar not appearing after initial exec. Though it will always
 - appear after xmonad reload. -- Fixed by moving to NixOS...
 - [ ] One config for two screen sizes (desktop/laptop)
 -}

import XMonad

import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras

import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing

import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Layout.Renamed
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IfMax

import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers

import XMonad.Hooks.InsertPosition

import XMonad.ManageHook
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

import XMonad.Actions.WindowBringer
import XMonad.Actions.FloatKeys
import XMonad.Actions.OnScreen

-- WIP colors and some ideas from Ethan Schoonover
-- https://github.com/altercation/dotfiles-tilingwm
--
-- Actually now the colors might differ from solarized. Need to check

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"
offwhite = "#839496"

active      = offwhite
activeWarn  = red
inactive    = base02
focusColor  = offwhite
unfocusColor = base02

border      = 2
gap         = 0
--gap         = 6
bGap        = 90        -- bigGap, mainly for zen layout
vbGap       = 240       -- vertical bigGap, mainly for zen layout

todoistUrl = "https://todoist.com"
calendarUrl = "https://calendar.google.com"
plannersCommand = "firefox --class \"planners\" -new-instance -P \"planners\" "
        ++ todoistUrl ++ " " ++ calendarUrl

comfyFloating = customFloating $ W.RationalRect (8/32) (0/16) (16/32) (16/16)

scratchpads =
    [ NS "planners" plannersCommand (className =? "planners")
        comfyFloating
    , NS "spotify" "spotify" (className =? "Spotify")
        comfyFloating
    , NS "terminal" "alacritty --class scratchterm" (resource =? "scratchterm")
        comfyFloating
    , NS "mail" "thunderbird" (className =? "thunderbird")
        comfyFloating
    , NS "calc" "alacritty --class calc --command \"kalker\"" (resource =? "calc")
        comfyFloating
        ]

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = " | "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = white . wrap " " "" . xmobarBorder "Bottom" offwhite 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppLayout          = white . wrap "" ""
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    , ppSort = fmap (filterOutWs [scratchpadWorkspaceTag].) (ppSort def)
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . white    . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . lowWhite . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#d33682" ""
    blue     = xmobarColor "#268bd2" ""
    white    = xmobarColor "#ffffff" ""
    yellow   = xmobarColor "#b58900" ""
    red      = xmobarColor "#dc322f" ""
    lowWhite = xmobarColor "#586e75" ""

-- My layouts
-- Disclaimer: this is a mess. Did this on a whim without much time to
-- fully understand transformers.
-- Need to read
-- https://hackage.haskell.org/package/xmonad-contrib-0.8/docs/XMonad-Layout-MultiToggle.html
-- as well as
-- https://github.com/altercation/dotfiles-tilingwm/blob/master/.xmonad/xmonad.hs

addGaps              = gaps [(U, gap),(D, gap),(L, gap),(R, gap)]
addBGaps             = gaps [(U, bGap),(D, bGap),(L, vbGap),(R, vbGap)]
addHGaps             = gaps [(U, gap),(D, gap),(L, vbGap),(R, vbGap)]
addSpacing           = spacing gap

nmaster  = 1      -- Default number of windows in the master pane
ratio    = 1/2    -- Default proportion of screen occupied by master pane
delta    = 3/100  -- Percent of screen to increment by when resizing panes

tiled    = reflectHoriz $ Tall nmaster delta ratio
myFull   = renamed [Replace "F"] $ noBorders Full
myTiled  = renamed [Replace "T"] $ addGaps $ addSpacing $ tiled
myMirror = renamed [Replace "MT"] $ addGaps $ addSpacing $ Mirror $ tiled
zen      = renamed [Replace "Z"] $ addHGaps $ Full
threeCol = renamed [Replace "TC"] $ addGaps $ addSpacing $ magnifiercz' 1.5 $ ThreeColMid nmaster delta ratio

data ZEN = ZEN deriving (Read, Show, Eq, Typeable)
instance Transformer ZEN Window where
 transform ZEN x k = k zen (\_ -> x)

data MYFULL = MYFULL deriving (Read, Show, Eq, Typeable)
instance Transformer MYFULL Window where
 transform MYFULL x k = k myFull (\_ -> x)

myLayout = (mkToggle (single ZEN)
    . mkToggle (single MYFULL)
    $ myTiled ||| (renamed [Replace "Z/T"] $ IfMax 1 zen myTiled) ||| myMirror ||| threeCol)

-- | The xmonad key bindings. Add, modify or remove key bindings here.
--
-- (The comment formatting character is used when generating the manpage)
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun
    , ((modMask .|. shiftMask, xK_q     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    , ((modMask,               xK_f ), sendMessage $ MT.Toggle MYFULL)
    , ((modMask,               xK_g ), sendMessage $ MT.Toggle ZEN)

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_l     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_c     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- ctrl-mod-[1..9] %! Force switch to workspace N on current physical/Xinerama screen
    -- mod-shift-[1..9] %! Move client to workspace N
    [ ((m .|. modMask, k), windows (f i))
      | (i, k) <- zip (workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
      , (f, m) <- [ (W.view, 0)
                  , (W.shift, shiftMask)
                  , (W.greedyView, controlMask) ]]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [ ((0,              xF86XK_MonBrightnessDown), spawn "xbacklight -2"  )
    , ((0,              xF86XK_MonBrightnessUp  ), spawn "xbacklight +2"  )
    , ((shiftMask,      xF86XK_MonBrightnessDown), spawn "xbacklight -10"  )
    , ((shiftMask,      xF86XK_MonBrightnessUp  ), spawn "xbacklight +10")
    ]
    ++
    [ ((0,              xF86XK_AudioPlay     ), spawn "playerctl play-pause"  )
    , ((0,              xF86XK_AudioPause    ), spawn "playerctl pause"  )
    , ((0,              xF86XK_AudioNext     ), spawn "playerctl next"  )
    , ((0,              xF86XK_AudioPrev     ), spawn "playerctl previous")
    , ((0,              xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0,              xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0,              xF86XK_AudioMute       ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ]
    ++
    [ ((modMask .|. shiftMask,   xK_s), spawn "maim -s -u | xclip -selection clipboard -t image/png")
    ]
    ++
    [ ((modMask .|. shiftMask,   xK_g   ), gotoMenu)
    , ((modMask .|. shiftMask,   xK_b   ), bringMenu)
    ]
--    ++
--    [ ((modMask .|. shiftMask, xK_l     ), withFocused (keysResizeWindow (10, 0) (0, 0)))
--    , ((modMask .|. shiftMask, xK_h     ), withFocused (keysResizeWindow (-10, 0) (0, 0)))
--    , ((modMask .|. shiftMask, xK_k     ), withFocused (keysResizeWindow (0, 10) (0, 0)))
--    , ((modMask .|. shiftMask, xK_j     ), withFocused (keysResizeWindow (0, -10) (0, 0)))
--    ]

myManageHook = composeAll . concat $
    [
        [ className =? ".zoom " --> doFloat ]
        , [ className =? ".zoom" --> doFloat ]
    ]

myConfig = def
    { modMask        = mod4Mask  -- Rebind Mod to the Super key
    , focusFollowsMouse = False
    , terminal       = "alacritty"
    , keys           = myKeys
    , manageHook = myManageHook <+> namedScratchpadManageHook scratchpads
    , layoutHook     = myLayout
    , borderWidth    = border
    , normalBorderColor = "#020202"
    , focusedBorderColor = focusColor
    }
    `additionalKeysP`
    [ ("M-C-f", spawn "firefox" )
    , ("M-C-t", namedScratchpadAction scratchpads "planners" )
    , ("M-C-s", namedScratchpadAction scratchpads "spotify" )
    , ("M-C-c", namedScratchpadAction scratchpads "calc" )
    , ("M-C-x", namedScratchpadAction scratchpads "terminal" )
    , ("M-C-m", namedScratchpadAction scratchpads "mail" )
    , ("S-M-C-l", spawn "xset s activate && sleep 30 && xset dpms force off" )
    , ("M-C-p", spawn "zathura \"$(fd -I -e \"pdf\" | dmenu -i -l 30)\"" )
    , ("M-C-S-s", spawn "maim -s -u $HOME/Screenshots/$(date +%Y-%m-%d-%H-%M-%S).png")
    ]

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

