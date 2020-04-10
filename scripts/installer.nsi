;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "Sections.nsh"
  !include "Memento.nsh"
  !include "WordFunc.nsh"
  !include "nsProcess.nsh"
  !include "FileFunc.nsh"
;--------------------------------
;General

  !define PRODUCT_NAME "Zettelkasten"
  !define VERSION @VERSION@
  !define PRODUCT_VERSION @VERSION@
  !define PRODUCT_GROUP "Zettelkasten"
  !define PRODUCT_PUBLISHER "ZKN-Team"
  !define PRODUCT_WEB_SITE "http://Zettelkasten.danielluedecke.de/"
  !define PRODUCT_DIR_REGKEY "SOFTWARE\Zettelkasten"
  !ifdef VER_MAJOR & VER_MINOR
    !define /ifndef VER_REVISION 0
    !define /ifndef VER_BUILD 0
  !endif
  !define VER_MAJOR 3
  !define VER_MINOR 0
  !define VER_REVISION 0
  !define VER_BUILD 0

  !define /ifndef VERSION 'anonymous-build'

  ;Name and file
 Name "Zettelkasten"

 !if ${NSIS_PTR_SIZE} > 4
   !define BITS 64
   !define NAMESUFFIX " (64 bit)"
 !else
   !define BITS 32
   !define NAMESUFFIX ""
 !endif

 !ifndef OUTFILE
   !define OUTFILE "Zettelkasten${BITS}-${VERSION}-setup.exe"
   ;!searchreplace OUTFILE "${OUTFILE}" Zettelkasten3 Zettelkasten
 !endif

 OutFile "${OUTFILE}"
 Caption "Zettelkasten ${VERSION}${NAMESUFFIX} Setup"
 !define REG_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Zettelkasten"
 Unicode true

  !ifdef NSIS_LZMA_COMPRESS_WHOLE
  ;  SetCompressor lzma
  !else
 ;   SetCompressor /SOLID lzma
  !endif

  BrandingText "${PRODUCT_GROUP} - ${PRODUCT_NAME} (${VER_MAJOR}.${VER_MINOR})"

  ;Default installation folder
  InstallDir "$PROGRAMFILES${BITS}\Zettelkasten"

  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin



;--------------------------------
;Version Information

  !ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
    VIProductVersion ${VER_MAJOR}.${VER_MINOR}.${VER_REVISION}.${VER_BUILD}
    VIAddVersionKey "FileVersion" "${VERSION}"
    VIAddVersionKey "ProductName" "Zettelkasten"
    VIAddVersionKey "CompanyName" "Zettelkasten"
    VIAddVersionKey "LegalCopyright" "Copyright ZKN-Team"
    VIAddVersionKey "FileDescription" "Zettelkasten - nach Niklas Luhmann"
  !endif
;Interface Settings

  !define MUI_ABORTWARNING

  ;Show all languages, despite user's codepage
  !define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
    Page custom PageReinstall PageLeaveReinstall
  !endif
  !insertmacro MUI_PAGE_LICENSE "$(MUILicense)"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY



  !insertmacro MUI_PAGE_INSTFILES

  !define MUI_FINISHPAGE_RUN "$INSTDIR\Zettelkasten.exe"
  !define MUI_FINISHPAGE_NOREBOOTSUPPORT
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Zettelkasten" SecZettelkasten

  SetShellVarContext all
  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  File /oname=Zettelkasten.jar .\..\target\Zettelkasten*.jar
  File /oname=Zettelkasten.exe .\..\target\Zettelkasten*.exe
  File /r .\..\target\jre
  File /r .\..\target\licenses

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${REG_UNINST_KEY}" "EstimatedSize" "$0"

SectionEnd

Section -Post
  ;Store installation folder
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" $INSTDIR
  !ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
    WriteRegDword HKLM "${PRODUCT_DIR_REGKEY}" "VersionMajor" "${VER_MAJOR}"
    WriteRegDword HKLM "${PRODUCT_DIR_REGKEY}" "VersionMinor" "${VER_MINOR}"
    WriteRegDword HKLM "${PRODUCT_DIR_REGKEY}" "VersionRevision" "${VER_REVISION}"
    WriteRegDword HKLM "${PRODUCT_DIR_REGKEY}" "VersionBuild" "${VER_BUILD}"
  !endif

  ;Create uninstaller
  WriteRegExpandStr HKLM "${REG_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegExpandStr HKLM "${REG_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "DisplayName" "Zettelkasten ${NAMESUFFIX}"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Zettelkasten.exe,0"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "DisplayVersion" "${VERSION}"
  !ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD
    WriteRegDWORD HKLM "${REG_UNINST_KEY}" "VersionMajor" "${VER_MAJOR}" ; Required by WACK
    WriteRegDWORD HKLM "${REG_UNINST_KEY}" "VersionMinor" "${VER_MINOR}" ; Required by WACK
  !endif
  WriteRegStr HKLM "${REG_UNINST_KEY}" "Publisher" "ZKN-Team" ; Required by WACK
  WriteRegStr HKLM "${REG_UNINST_KEY}" "RegOwner" "ZKN-Team"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "RegCompany" "ZKN-Team"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "URLInfoAbout" "http://zettelkasten.danielluedecke.de/"
  WriteRegStr HKLM "${REG_UNINST_KEY}" "HelpLink" "http://zettelkasten.danielluedecke.de/"
  WriteRegDWORD HKLM "${REG_UNINST_KEY}" "NoModify" "1"
  WriteRegDWORD HKLM "${REG_UNINST_KEY}" "NoRepair" "1"
  ${MakeARPInstallDate} $1
  WriteRegStr HKLM "${REG_UNINST_KEY}" "InstallDate" $1

  WriteUninstaller "$INSTDIR\uninstall.exe"


    ;Create shortcuts
    CreateShortcut "$SMPROGRAMS\Zettelkasten.lnk" "$INSTDIR\Zettelkasten.exe"

  SectionEnd

;--------------------------------
;Installer Functions

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY
  SectionSetFlags ${SecZettelkasten} 17 ;section mandatory --> https://nsis.sourceforge.io/Graying_out_Section_(define_mandatory_sections)

FunctionEnd


!ifdef VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD

Var ReinstallPageCheck

Function PageReinstall

  ReadRegStr $R0 HKLM "${PRODUCT_DIR_REGKEY}" ""
  ReadRegStr $R1 HKLM "${REG_UNINST_KEY}" "UninstallString"
  ${IfThen} "$R0$R1" == "" ${|} Abort ${|}

  StrCpy $R4 "older"
  ReadRegDWORD $R0 HKLM "${PRODUCT_DIR_REGKEY}" "VersionMajor"
  ReadRegDWORD $R1 HKLM "${PRODUCT_DIR_REGKEY}" "VersionMinor"
  ReadRegDWORD $R2 HKLM "${PRODUCT_DIR_REGKEY}" "VersionRevision"
  ReadRegDWORD $R3 HKLM "${PRODUCT_DIR_REGKEY}" "VersionBuild"
  ${IfThen} $R0 = 0 ${|} StrCpy $R4 "unknown" ${|} ; Anonymous builds have no version number
  StrCpy $R0 $R0.$R1.$R2.$R3

  ${VersionCompare} ${VER_MAJOR}.${VER_MINOR}.${VER_REVISION}.${VER_BUILD} $R0 $R0
  ${If} $R0 == 0
    StrCpy $R1 "Zettelkasten ${VERSION} is already installed. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Add/Reinstall components"
    StrCpy $R3 "Uninstall Zettelkasten"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose the maintenance option to perform."
    StrCpy $R0 "2"
  ${ElseIf} $R0 == 1
    StrCpy $R1 "An $R4 version of Zettelkasten is installed on your system. It's recommended that you uninstall the current version before installing. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Uninstall before installing"
    StrCpy $R3 "Do not uninstall"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose how you want to install Zettelkasten."
    StrCpy $R0 "1"
  ${ElseIf} $R0 == 2
    StrCpy $R1 "A newer version of Zettelkasten is already installed! It is not recommended that you install an older version. If you really want to install this older version, it's better to uninstall the current version first. Select the operation you want to perform and click Next to continue."
    StrCpy $R2 "Uninstall before installing"
    StrCpy $R3 "Do not uninstall"
    !insertmacro MUI_HEADER_TEXT "Already Installed" "Choose how you want to install Zettelkasten."
    StrCpy $R0 "1"
  ${Else}
    Abort
  ${EndIf}

  nsDialogs::Create 1018
  Pop $R4

  ${NSD_CreateLabel} 0 0 100% 24u $R1
  Pop $R1

  ${NSD_CreateRadioButton} 30u 50u -30u 8u $R2
  Pop $R2
  ${NSD_OnClick} $R2 PageReinstallUpdateSelection

  ${NSD_CreateRadioButton} 30u 70u -30u 8u $R3
  Pop $R3
  ${NSD_OnClick} $R3 PageReinstallUpdateSelection

  ${If} $ReinstallPageCheck != 2
    SendMessage $R2 ${BM_SETCHECK} ${BST_CHECKED} 0
  ${Else}
    SendMessage $R3 ${BM_SETCHECK} ${BST_CHECKED} 0
  ${EndIf}

  ${NSD_SetFocus} $R2

  nsDialogs::Show

FunctionEnd

Function PageReinstallUpdateSelection

  Pop $R1

  ${NSD_GetState} $R2 $R1

  ${If} $R1 == ${BST_CHECKED}
    StrCpy $ReinstallPageCheck 1
  ${Else}
    StrCpy $ReinstallPageCheck 2
  ${EndIf}

FunctionEnd

Function PageLeaveReinstall

  ${NSD_GetState} $R2 $R1

  StrCmp $R0 "1" 0 +2 ; Existing install is not the same version?
    StrCmp $R1 "1" reinst_uninstall reinst_done

  StrCmp $R1 "1" reinst_done ; Same version, skip to add/reinstall components?

  reinst_uninstall:
  ReadRegStr $R1 HKLM "${REG_UNINST_KEY}" "UninstallString"

  ;Run uninstaller
    HideWindow

    ClearErrors
    ExecWait '$R1 _?=$INSTDIR' $0

    BringToFront

    ${IfThen} ${Errors} ${|} StrCpy $0 2 ${|} ; ExecWait failed, set fake exit code

    ${If} $0 <> 0
      MessageBox MB_ICONEXCLAMATION "Uninstallation was aborted or failed."
      Abort
    ${Else}
      StrCpy $0 $R1 1
      ${IfThen} $0 == '"' ${|} StrCpy $R1 $R1 -1 1 ${|} ; Strip quotes from UninstallString
      Delete $R1
      RMDir $INSTDIR
    ${EndIf}

  reinst_done:

FunctionEnd


!endif # VER_MAJOR & VER_MINOR & VER_REVISION & VER_BUILD

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecZettelkasten ${LANG_ENGLISH} "Zettelkasten"
  LangString DESC_SecZettelkasten ${LANG_GERMAN} "Zettelkasten"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecZettelkasten} $(DESC_SecZettelkasten)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

  LicenseLangString MUILicense ${LANG_ENGLISH} .\..\src\main\resources\eula\eula_en.rtf
  LicenseLangString MUILicense ${LANG_GERMAN} .\..\src\main\resources\eula\eula_de.rtf

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  SetShellVarContext all

  Call un.checkIfRunning
   
  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\Zettelkasten*"
  RMDir /r "$INSTDIR\jre"
  RMDir /r "$INSTDIR\licenses"
  RMDir /r "$INSTDIR\eula"
  Delete "$INSTDIR\uninstall.exe"

  RMDir "$INSTDIR"
  Delete "$SMPROGRAMS\Zettelkasten.lnk"


  DeleteRegKey HKLM "${REG_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE

FunctionEnd


Function un.checkIfRunning
  beginning:
  DetailPrint "Checking if Zettelkasten is still running ..."
  ${nsProcess::FindProcess} "Zettelkasten.exe" $R0


  System::Call 'kernel32::OpenMutex(i 0x100000, b 0, t "et3-{3e311972-85c4-4328-8cfb-7579c824c0d7}") i .R0'
  IntCmp $R0 0 notRunning
  System::Call 'kernel32::CloseHandle(i $R0)'
  MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "Zettelkasten is running. Please close it first." IDRETRY beginning IDCANCEL cancel
  cancel: 
    ${nsProcess::Unload}
    Abort
  
  notRunning:
     ${nsProcess::Unload}
FunctionEnd
