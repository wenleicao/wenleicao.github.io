<#
this script enable us to run only current day is not holidy and weekend
need to pass in the env param 
#>

param([string]$env="dev") 

function IsHoliday([datetime] $DateToCheck = (Get-Date)){
  [int]$year = $DateToCheck.Year
  If($DateToCheck.Day -eq 31 -and $DateToCheck.Month -eq 12 -and $DateToCheck.DayOfWeek -eq 'Friday'){$year = $year + 1}
  $HolidaysInYear = (@(
    [datetime]"1/1/$year", #New Year's Day on Saturday will be observed on 12/31 of prior year
    (23..30 | %{([datetime]"5/1/$year").AddDays($_)}|?{$_.DayOfWeek -eq 'Monday'})[-1], #Memorial Day
    $(If($year -ge 2021){[datetime]"6/19/$year"}Else{[datetime]"1/1/$year"}), #Juneteenth is a federal holiday since 2021
    [datetime]"7/4/$year",#Independence Day
    (0..6 | %{([datetime]"9/1/$year").AddDays($_)}|?{$_.DayOfWeek -eq 'Monday'})[0], #Labor Day - first Mon in Sept.
    (0..29 | %{([datetime]"11/1/$year").AddDays($_)}|?{$_.DayOfWeek -eq 'Thursday'})[3],#Thanksgiving - last Thu in Nov.
    [datetime]"12/25/$year"#Christmas
  ) | %{$_.AddDays($(If($_.DayOfWeek -eq 'Saturday'){-1}) + $(If($_.DayOfWeek -eq 'Sunday'){+1})) })
  Return $HolidaysInYear.Contains($DateToCheck.Date)
}

function IsBusinessday([datetime] $DateToCheck = (Get-Date)){

    If (IsHoliday($DateToCheck) ) {Return 0}          
    elseif ($DateToCheck.DayOfWeek -eq "Saturday") {Return 0}
    elseif ($DateToCheck.DayOfWeek -eq "Sunday") {Return 0} 
    else {  Return 1 }

}



Set-Location $PSScriptRoot  #get running script location and set as default
conda activate time_series


Write-Host "Job started at $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")"

$currentDate = Get-Date

If (IsBusinessday($currentDate) -eq 1) {    
    python run.py $env 
}
else {
    Write-Host "not a business day, quit job" 
    exit
}

Write-Host "Job ended at $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" 
