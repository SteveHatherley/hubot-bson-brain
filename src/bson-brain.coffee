bsonlib = require "bson"
pathlib = require "path"
fs = require "fs"

bson = new bsonlib.BSONPure.BSON

module.exports = (robot) ->
    homedir = if process.platform == "win32" then process.env.USERPROFILE else process.env.HOME
    path = process.env.HUBOT_BSON_BRAIN_PATH or homedir
    path = pathlib.join path, ".hubot-brain.bson"

    try
        data = fs.readFileSync path

        if data?
            robot.brain.mergeData bson.deserialize(data)
    catch error
        console.log "bson brain: Unable to read file", error unless error.code is "ENOENT"

    robot.brain.on "save", (data) ->
        robot.logger.debug "bson brain: Save event"
        fs.writeFileSync path, bson.serialize(data, false, true, false)
