-- main.applescript
-- Dispense Items Incrementally
-- Copyright 2007 Nyhthawk Productions. All rights reserved.

property item_list : {}

on run {input, parameters}
	
	set temp_folder_path to |temporary items path| of parameters
	if temp_folder_path does not end with "/" then set temp_folder_path to temp_folder_path & "/"
	
	if the class of input is not list then set input to input as list
	if input is {} then error (my localized_string("NO_PASSED_ITEMS_ERROR"))
	
	-- CHECK TO SEE IF FIRST RUN BY CHECKING TO SEE IF FILE EXISTS IN TEMP FOLDER
	try
		(temp_folder_path & "com.NyhthawkProductions.Automator.DispenseItems.plist") as POSIX file as alias
	on error
		-- if the file doesn't exist, create it
		do shell script "defaults write " & (temp_folder_path & "com.NyhthawkProductions.Automator.DispenseItems flag -bool YES")
		-- reset the stored list to the passed items
		set item_list to input
	end try
	
	-- check to see if the stored list has been processed. If it has, then stop the workflow.
	if item_list is {} then
		error number -128
	else
		-- otherwise peel off the first item in the stored list
		set the passed_item to the first item of the item_list
		-- set the list to the remaining items in the list
		set the item_list to the rest of the item_list
		-- return the first list item
		return the passed_item
	end if
end run

on localized_string(key_string)
	return localized string key_string in bundle with identifier "com.NyhthawkProductions.Automator.DispenseItemsIncrementally"
end localized_string
