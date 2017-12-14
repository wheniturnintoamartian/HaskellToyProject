module TempFile where

import System.IO
import System.Directory (getTemporaryDirectory, removeFile)
import Control.Exception (catch, finally)

-- The main entry point. Work with a temp file in myAction.
someFunc :: IO ()
someFunc = withTempFile "MyText.txt" myAction

{- The guts of the program. Called with the path and handle of a temporary file. When this function exits, that file will be closed and deleted because myAction was called from withTempFile. -}
myAction :: FilePath -> Handle -> IO ()
myAction tempName tempHandle =
    do -- Start by displaying a greeting on the terminal.
       putStrLn "Welcome to Tempfile.hs"
       putStrLn $ "I have a temporary file at " ++ tempName

       -- Let's see what the initial position is.
       pos <- hTell tempHandle
       putStrLn $ "My initial position is " ++ show pos

       -- Now, write some data to the temporary file
       let tempData = show [1..10]
       putStrLn $ "Writing one line containing " ++ show (length tempData) ++ " bytes: " ++ tempData
       hPutStrLn tempHandle tempData

       -- Get our new position. This doesn't actually modify pos in memory, but makes the name "pos" correspond to a different value for the remainder of the "do" block.
       pos <- hTell tempHandle
       putStrLn $ "After writing, my new position is " ++ show pos

       -- Seek to the beginning of the file and display it.
       putStrLn "The file content is: "
       hSeek tempHandle AbsoluteSeek 0

       -- hGetContents performs a lazy read of the entire file
       c <- hGetContents tempHandle

       -- Copy the file byte-for-byte to stdout, followed by \n.
       putStrLn c

       -- Let's also display it as a Haskell literal.
       putStrLn "Which could be expressed as this Haskell literal: "
       print c

{- This function takes two parameters: a filename pattern and another function. It will create a temporary file, and pass the name and Handle of that file to the given function. The temporary file is created
with openTempFile. The directory is the one indicated by getTemporaryDirectory, or, if the system has no notion of a temporary directory, "." is used. The given pattern is passed to openTempFile. After the given
function terminates, even if it terminates due to an exception, the Handle is closed and the file is deleted. -}
withTempFile :: String -> (FilePath -> Handle -> IO a) -> IO a
withTempFile pattern function =
    do -- The library ref says that getTemporaryDirectory may raise on exception on systems that have no notion of a temporary directory. So, we run getTemporaryDirectory under catch. catch takes two functions:
       -- one to run, and a different one to run if the first raised an exception. If getTemporaryDirector raised an exception, just use "." (the current working directory).
       tempDirectory <- catch (getTemporaryDirectory) (\_ -> return ".")
       (tempFile, tempHandle) <- openTempFile tempDirectory pattern

       -- Call (func tempFile tempHandle) to perform the action on the temporary file. finally takes two actions. The first is the action to run. The second is an action to run after the firs, regardless of
       -- the temporary file is always deleted. The return value from finally is the first action's return value.
        finally (function tempFile tempHandle) (do hClose tempHandle; removeFile tempFile)

