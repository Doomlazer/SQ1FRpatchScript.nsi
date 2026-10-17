# create patches
# "C:\Program Files (x86)\NSIS\Bin\GenPat.exe" "C:\GOG Games\Space Quest\AGIDATA.OVL" "C:\Users\micah\Desktop\Space Quest I FR\AGIDATA.OVL" AGIDATA.OVL.patch

!include MUI2.nsh
Unicode true
RequestExecutionLevel user
!define MUI_ICON "sq1_icon.ico"
!define MUI_UNICON "uninstall.ico"

!define BACKUPDIR "SIERRA_ORIG_ENGLISH"
!define UNINSTALLER_NAME "D${U+00E9}sinstaller_-_SQ1_AGI_Fr.exe"
!define MUI_COMPONENTSPAGE_NODESC

Function .onVerifyInstDir
    IfFileExists "$INSTDIR\AGIDATA.OVL" +2 0
        abort
FunctionEnd

!macro UpdateFile FILE
    IfFileExists "$INSTDIR\${FILE}" +3 0
        MessageBox MB_OK "Missing: ${FILE}. The selected folder does not contain the required SQ1 2.2 files. Please close the patcher and try again."
        abort
    IfFileExists "$INSTDIR\PATCH_FR\*.*" +2 0
        CreateDirectory "$INSTDIR\PATCH_FR"
    CopyFiles "$INSTDIR\${FILE}" "$INSTDIR\PATCH_FR\${FILE}"
    
    DetailPrint "Updating ${FILE} using patch..."
    !insertmacro VPatchFile ${FILE}.patch "$INSTDIR\PATCH_FR\${FILE}" "$INSTDIR\PATCH_FR\${FILE}.tmp"

    IfErrors 0 +2
        abort
!macroend

!macro CopyFile FILE
    DetailPrint "Copying ${FILE} to French install folder..."
    CopyFiles "$INSTDIR\${FILE}" "$INSTDIR\PATCH_FR\${FILE}"

    IfErrors 0 +2
        abort
!macroend

Name "SQ1 Fr"

OutFile "SQ1-fran${U+00E7}aise-patcher.exe"
BrandingText "      Space Quest I AGI Fr"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "welcome.bmp"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS #enable options
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "French"
!include "VPatchLib.nsh"

#DirText "Ce patch est compatible avec la version 2.2 uniquement.${U+000A}Veuillez s${U+00E9}lectionner la r${U+00E9}pertoire d'installation de la version originale.${U+000A}Le patch fera la mise ${U+00E0} jour des ressources sans affecter le jeu en anglais.${U+000A}Un sous-r${U+00E9}pertoire nomm${U+00E9} PATCH_FR inclura la traduction fran${U+00E7}aise.${U+000A}Ce patch est comme un greffon, m${U+00EA}mes ressources, pour deux langues." "R${U+00E9}pertoire contenant SQ1 original :"


Section "-Update file"
    ; Set output path to the installation directory
    SetOutPath $INSTDIR

    #IfFileExists SIERRA.COM 0 +2
    #    CopyFiles "SIERRA.COM" "SQ.COM"
    IfFileExists SQ.EXE 0 +2
        CopyFiles "SQ.EXE" "SQ.COM"
    IfFileExists AGI +2 0
        File AGI
    !insertmacro UpdateFile AGI
    #IfFileExists SIERRA.COM 0 +2
    #    File SQ.COM
    #!insertmacro UpdateFile SQ.COM
    !insertmacro UpdateFile VOL.0
    !insertmacro UpdateFile VOL.1
    !insertmacro UpdateFile VOL.2
    !insertmacro UpdateFile LOGDIR
    !insertmacro UpdateFile OBJECT
    !insertmacro UpdateFile PICDIR
    !insertmacro UpdateFile VIEWDIR
    !insertmacro UpdateFile SNDDIR
    !insertmacro UpdateFile WORDS.TOK
    !insertmacro UpdateFile AGIDATA.OVL
    !insertmacro UpdateFile CGA_GRAF.OVL
    #!insertmacro UpdateFile EGA_GRAF.OVL
    #!insertmacro UpdateFile IBM_OBJS.OVL
    !insertmacro UpdateFile JR_GRAF.OVL

    SetOutPath "$INSTDIR\PATCH_FR\"
    File uninstall.ico
    File sq1_icon.ico
    File sq1.ini
    File agi-font-dos.bin
    File MYEGA.CPI
    File WORDS.TOK.EXTENDED
    File SQ1.bat
    File SQ.COM
    File IBM_OBJS.OVL
    File EGA_GRAF.OVL

    # Manuel
    CreateDirectory "$INSTDIR\PATCH_FR\Manuel"
    File /r "Manuel\"

    # scummvm
    CreateDirectory "$INSTDIR\PATCH_FR\scummvm"
    File /r "scummvm\"

    # DOSBox
    CreateDirectory "$INSTDIR\PATCH_FR\DOSBOX"
    File /r "DOSBOX\"
    
    WriteUninstaller $INSTDIR\${UNINSTALLER_NAME}

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PATCH_FR" \
                     "DisplayName" "SQ1 AGI - Version fran${U+00E7}aise"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PATCH_FR" \
                     "UninstallString" "$INSTDIR\${UNINSTALLER_NAME}"
   
SectionEnd

Section /o "Ajouter au menu d${U+00E9}marrer" start_id
    # Shortcuts
    SetOutPath "$INSTDIR\PATCH_FR\"
    CreateShortCut "$INSTDIR\PATCH_FR\SQ1 AGI Fr DOSBox.lnk" "$INSTDIR\PATCH_FR\sq1.bat" "" "$INSTDIR\PATCH_FR\sq1_icon.ico"
    CreateShortCut "$INSTDIR\PATCH_FR\SQ1 AGI Fr ScummVM.lnk" "$INSTDIR\PATCH_FR\scummvm\scummvm.exe" "-c .\sq1.ini sq1-fr" "$INSTDIR\PATCH_FR\sq1_icon.ico"
    CreateShortCut "$INSTDIR\PATCH_FR\SQ1 AGI Fr Manuel.lnk" "$INSTDIR\PATCH_FR\Manuel\" ""
    SetOutPath $INSTDIR
    CreateShortCut "$INSTDIR\PATCH_FR\D${U+00E9}sinstaller SQ1 AGI Fr.lnk" "$INSTDIR\D${U+00E9}sinstaller_-_SQ1_AGI_Fr.exe" "" "$INSTDIR\PATCH_FR\uninstall.ico"
  
    CreateDirectory "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise"
    CopyFiles "$INSTDIR\PATCH_FR\SQ1 AGI Fr DOSBox.lnk" "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise\"
    CopyFiles "$INSTDIR\PATCH_FR\SQ1 AGI Fr ScummVM.lnk" "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise\"
    CopyFiles "$INSTDIR\PATCH_FR\D${U+00E9}sinstaller SQ1 AGI Fr.lnk" "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise\"
    CopyFiles "$INSTDIR\PATCH_FR\SQ1 AGI Fr Manuel.lnk" "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise\"
    Delete "$INSTDIR\PATCH_FR\SQ1 AGI Fr Manuel.lnk"
SectionEnd

Section /o "SQ1 lanceur DOSBox" desktop_d_id
    CopyFiles "$INSTDIR\PATCH_FR\SQ1 AGI Fr DOSBox.lnk" "$DESKTOP\"
    Delete "$INSTDIR\PATCH_FR\SQ1 AGI Fr DOSBox.lnk"
SectionEnd

Section /o "SQ1 lanceur ScummVM" desktop_s_id
    CopyFiles "$INSTDIR\PATCH_FR\SQ1 AGI Fr ScummVM.lnk" "$DESKTOP\"
    Delete "$INSTDIR\PATCH_FR\SQ1 AGI Fr ScummVM.lnk"
SectionEnd


Section "Uninstall"
    SetOutPath "$TEMP"
    RMDir /r "$SMPROGRAMS\Space Quest 1 AGI - Version fran${U+00E7}aise"
    Delete "$DESKTOP\SQ1 AGI Fr DOSBox.lnk"
    Delete "$DESKTOP\SQ1 AGI Fr ScummVM.lnk"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PATCH_FR"
    RMDir /r /REBOOTOK "$INSTDIR\PATCH_FR\"
    Delete "$INSTDIR\${UNINSTALLER_NAME}"
SectionEnd
 
Function .onInit
    SectionSetFlags ${start_id} 1
    SectionSetFlags ${desktop_d_id} 0
    SectionSetFlags ${desktop_s_id} 0
FunctionEnd

