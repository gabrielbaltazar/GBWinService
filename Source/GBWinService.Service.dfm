object GBWinService: TGBWinService
  OldCreateOrder = False
  DisplayName = 'GBWinService'
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  Height = 150
  Width = 215
end
