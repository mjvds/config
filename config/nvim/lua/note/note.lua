local os = require 'os'
local io = require 'io'
local fn = vim.fn
local utils = require 'utils'
local M = {}

local USER = os.getenv('USER')
local DAYS_NAME_ENUM = {
  [1] = 'Sunday',
  [2] = 'Monday',
  [3] = 'Tuesday',
  [4] = 'Wednesday',
  [5] = 'Thursday',
  [6] = 'Friday',
  [7] = 'Saturday'
}

local DAYS_INDEX_ENUM = {
  ['Sunday']    = 1,
  ['Monday']    = 2,
  ['Tuesday']   = 3,
  ['Wednesday'] = 4,
  ['Thursday']   = 5,
  ['Friday']    = 6,
  ['Saturday']  = 7
}

local function file_exists(path)
  local _, err  = io.open(path, 'r')
  if err then
    return false
  end
  return true
end

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function string_split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function get_previous_date_from_now(day)
  local day_index = DAYS_INDEX_ENUM[day]
  local current_day_index = DAYS_INDEX_ENUM[os.date("%A")]
  local days_from_now = current_day_index - day_index
  days_from_now_in_hrs = 24 * (days_from_now)
  return string.lower(os.date("%b-%d-%Y", os.time() - days_from_now_in_hrs * 60 * 60))
end

local function ternary(cond, truthy, falsy)
  if cond then
    return truthy
  end
  return falsy
end

M.file_path = '/home/' .. USER .. '/.mark/task_reports/tasknote.txt'
M.note_dest_path = '/home/' .. USER .. '/.mark/task_reports/'
M.case_starting_sym = '#'
M.note_starting_sym = '@'
M.days_of_week = { 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' }
M.days_in_a_week = 7

local function parse_note_to_tbl()
  local file, err = io.open(M.file_path, 'r')
  if err then
    print('file ' .. M.file_path .. ' not found.')
    return
  end

  local note_cases = {}
  local note_content = {}

  local starting_day = nil
  local ending_day = nil

  for line in file:lines() do
    local is_note = starts_with(line, M.note_starting_sym)
    if is_note then
      local note_split = string_split(line, '-')
      local day = string.gsub(note_split[1], M.note_starting_sym, '')
      if starting_day == nil then
        starting_day = day
      end
      if not note_content[day] then
        note_content[day] = {}
      end
      local note_msg = note_split[2]
      table.insert(note_content[day], note_msg)
      ending_day = day
    end

    local is_case = starts_with(line, M.case_starting_sym) 
    if is_case then
      table.insert(note_cases, line)
    end

  end
  
  local starting_day_parsed = get_previous_date_from_now(starting_day)
  local ending_day_parsed = get_previous_date_from_now(ending_day)
  print(starting_day_parsed .. " " .. ending_day_parsed)
  return note_cases, note_content, starting_day_parsed, ending_day_parsed
end

local function parse_note()
  local cases, notes, starting_day, ending_day = parse_note_to_tbl()

  local formatted_cases = 'git commit -m "Fixe case ' .. table.concat(cases, " ,") .. '"'
  local formatted_notes = ""

  for index,day in pairs(M.days_of_week) do

    local day_with_date = day .. '(' .. get_previous_date_from_now(day) .. ')'
    if notes[day] ~= nil then
      formatted_notes = formatted_notes .. '\n' .. day_with_date .. '\n'
      for k,v in pairs(notes[day]) do
        formatted_notes = formatted_notes .. '    - ' .. v .. '\n'
      end
    else
      formatted_notes = formatted_notes .. '\n' .. day_with_date .. '\n'
    end
  end

  return formatted_cases, formatted_notes, starting_day, ending_day
end

function M.add(day)
  local current_day = day or os.date("%A")
  local case = fn.input('Enter case number: ') or nil
  local note = fn.input(
    'Enter note: ',
    ternary(case and case ~= '', 'resolved case #' .. case .. ' to fixed', '')
  ) or nil

  if case and note then
    if not file_exists(M.file_path) then
      os.execute('touch ' .. M.file_path)
    end

    local file, err = io.open(M.file_path, 'a')
    if case and case ~= '' then
      file:write(M.case_starting_sym .. case .. '\n')
    end

    if note then
      file:write(M.note_starting_sym .. current_day .. '-' .. note .. '\n')
    end

    file:close()
  end
end

function M.add_by_day()
  local dayInput = fn.input()
  if dayInput == nil or dayInput == '' then
    return
  end
  local dayIndex = utils.find_index_by_value(M.days_of_week, dayInput)
  if dayIndex == 0 then
    print("Invalid day")
  end
  M.add(dayInput)
end

function M.generate()
  local formatted_cases, formatted_notes, starting_day, ending_day = parse_note()
  local note_content = formatted_cases .. "\n\n" .. formatted_notes
  local new_note_file, err = io.open('/tmp/note_file', 'w')
  if err then
    print(err)
    return
  end
  new_note_file:write(note_content)
  new_note_file:close()

  local note_filename = 'mark_' .. starting_day .. '_to_' .. ending_day .. '.txt'
  os.execute('mv /tmp/note_file "' .. M.note_dest_path .. note_filename .. '"')
  print(note_filename .. 'is generated')

end

function M.preview()
  local formatted_cases, formatted_notes = parse_note()
  print(formatted_cases .. '\n' .. '\n' .. formatted_notes)
end

return M
