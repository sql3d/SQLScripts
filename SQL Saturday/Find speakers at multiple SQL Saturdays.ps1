<#
Author: Wayne Sheffield

Purpose: 
Powershell script to see if there are any speakers that you have selected to speak 
at your SQL Saturday event that are speaking at any other event on the same day.

To Use:
1. Set the "$MyEventNumber" variable below to your SQL Saturday event number.
2. Run script (when this script was run, there were 527 SQL Saturdays to evaluate. This took 3 minutes, 15 seconds)

Optional:
Set the $EventNumber variable to the lowest SQL Saturday event number that is the same day as your event.

Initial idea for how to load this data from Steve Jones' blog post at https://voiceofthedba.wordpress.com/2015/01/26/downloading-sql-saturday-data/.

Debug options: If the @debug option is set to a non-zero value, then these actions will occur:
1: the list of speakers at your event will be output to the screen.
2: the "guide" node of your event will be output to the screen.
3: the event name of the events being loaded will be output to the screen.
#>

cls;
$MyEventNumber = 486;
$debug = 0;
$EventNumber = 500;

$baseUrl = "http://www.sqlsaturday.com/eventxml.aspx?sat=";
$Failed = 0;
$DupeSpeakers = New-Object System.Object;
$MyEventSpeakers = New-Object System.Collections.ArrayList
$doc = New-Object System.Xml.XmlDocument;

#load in "My" event information and speakers
$sourceURL = $BaseURL + $MyEventNumber;
$doc.Load($sourceURL);
$guide = $doc.SelectNodes("GuidebookXML/guide");
if ($debug -eq 2) {Write-Host $guide};
$MyEventName = $guide.name;
$MyEventDate = $guide.startDate;
foreach ($speaker in $doc.SelectNodes("GuidebookXML/speakers/speaker")) {
    $MyEventSpeakers.Add($speaker.name) | Out-Null;
}
Write-Host "My Event/Date: " $MyEventName $MyEventDate;
if ($debug -eq 1) {
    # print out the list of speakers at my event
    $MyEventSpeakers | Sort-Object
}
Write-Host "";

while ($EventNumber -lt 9999) {
    if ($MyEventNumber -ne $EventNumber) {
        $sourceURL = $BaseURL + $EventNumber;
        if ($debug -eq 2) {
            Write-Host "Source URL: $sourceURL";
        } # debug messages

        Try {
            $doc.Load($sourceURL);
            $event = $doc.SelectNodes("GuidebookXML/guide");
            $EventName = $event.name;
            $EventDate = $event.startDate;
            if ($debug -eq 3) {
                Write-Host $EventName $EventDate;
            }

            if ($MyEventDate -eq $EventDate) {
                Write-Host "Checking speakers at: " $EventName;
                $speakers = $doc.SelectNodes("GuidebookXML/speakers/speaker");
                foreach ($speaker in $speakers) {
                    if ($MyEventSpeakers -contains $speaker.name) {
                        #OMG - this speaker is speaking somewhere else!!!
                        $DupeSpeakers | Add-Member -type NoteProperty -name Event -Value $event.name;
                        $DupeSpeakers | Add-Member -type NoteProperty -name Speaker -Value $speaker.name;
                    } #check for speaker speaking somewhere else
                } # check each speaker
            } # same event date as my event
        } #try

        Catch
        {
            # At some point, the EventNumber will reach a point past any current SQL Saturdays.
            # Keep track of the number of times that this script could not load a file in, 
            # and when it gets to 10 times, abort the script by setting the current EventNumber to 9999.
            $Failed = $Failed + 1;
            if ($Failed -eq 10) {
                $EventNumber = 9999
            } #failed 10 times
        } #catch
    } # not my event
    $EventNumber = $EventNumber + 1;
} #while loop
#show results if any
if (-Not ($DupeSpeakers)) {
    $DupeSpeakers | Sort-Object Event, Speaker | Format-Table;
}