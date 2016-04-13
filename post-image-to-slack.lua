cjson = require "cjson"

lastFileName = ""
lastFilePath = ""
maxMod = 0

currentDir = "/DCIM"
for dirName in lfs.dir(currentDir) do
  dirPath = currentDir.."/"..dirName
  subDir = lfs.attributes(dirPath, "mode")
  if subDir == "directory" then
    for fileName in lfs.dir(dirPath) do
      filePath = dirPath.."/"..fileName
      mod = lfs.attributes(filePath, "modification")
      if mod > maxMod and string.match(fileName, "%JPG$") == "JPG" then
        maxMod = mod
        lastFileName = fileName
        lastFilePath = filePath
      end
    end
  end
end

boundary = "--61141483716826"
contenttype = "multipart/form-data; boundary=" .. boundary
token = "xoxp-19424584162-19418489300-26787938816-29eec0abaa"
channels = "C0KCHFL5N"
mes = "--" ..  boundary .. "\r\n"
  .."Content-Disposition: form-data; name=\"file\"; filename=\""..lastFileName.."\"\r\n"
  .."\r\n"
  .."<!--WLANSDFILE-->\r\n"
  .."--" .. boundary .. "--\r\n"

print(mes)
print(lastFileName)
print(lastFilePath)

blen = lfs.attributes(lastFilePath,"size") + string.len(mes) - 17
b, c, h = fa.request{
  url = "https://slack.com/api/files.upload?token="..token.."&channels="..channels,
  method = "POST",
  headers = {
    ["Content-Length"] = tostring(blen),
    ["Content-Type"] = contenttype
  },
  file = lastFilePath,
  body = mes
}

print(b)
print(c)
print(h)
