module Main (main) where

import Eclair.ArgParser
import Eclair
import GHC.IO.Encoding
import System.Directory
import qualified Data.Text.IO as TIO


tryReadFile :: FilePath -> IO (Maybe Text)
tryReadFile file = do
  fileExists <- doesFileExist file
  if fileExists
    then Just <$> readFileText file
    else pure Nothing

main :: IO ()
main = do
  setLocaleEncoding utf8
  arguments <- getArgs
  parseArgs arguments >>= \case
    Compile cfg -> do
      let file = mainFile cfg
          fn = case emitKind cfg of
            EmitSimplifiedAST -> emitSimplifiedAST
            EmitRA -> emitRA
            EmitEIR -> emitEIR
            EmitLLVM -> emitLLVM
          params = Parameters (cpuTarget cfg) tryReadFile
      whenLeftM_ (fn params file) $ \errs -> do
        let errActions =
              errs
                & map handleErrorsCLI
                & intersperse (TIO.hPutStr stderr "\n")
        sequence_ errActions
