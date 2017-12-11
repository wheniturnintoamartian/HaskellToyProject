{- | Define a function that takes an integer representing the maximum
id value to look up. Will fetch all matching rows from the test database
and print them to the screen in a friendly format. -}
module Lib
    ( someFunc
    ) where

import Control.Monad
import Database.HDBC
import Database.HDBC.MySQL

someFunc :: Int -> IO ()
someFunc maxId = do -- Connect to the database
                    conn <- connectMySQL defaultMySQLConnectInfo { mysqlHost = "127.0.0.1", mysqlUser = "root", mysqlPassword = "fasdf" }
                    putStrLn (dbServerVer conn)
                    -- Run the query and store the results in r
                    r <- quickQuery' conn
                         "select id, description from test where id <= ? ORDER BY id, description"
                         [toSql maxId]
                    -- Convert each row into a String
                    let stringRows = map convRow r
                    -- Print the rows out
                    mapM_ putStrLn stringRows
                    -- And disconnect from the database
                    disconnect conn
                 where convRow :: [SqlValue] -> String
                       convRow [sqlId, sqlDesc] =
                          show intid ++ ": " ++ desc
                            where intid = (fromSql sqlId)::Integer
                                  desc = case fromSql sqlDesc of
                                           Just x -> x
                                           Nothing -> "NULL"
                       convRow x = fail $ "Unexpected result: " ++ show x
