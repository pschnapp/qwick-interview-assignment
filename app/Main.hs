import Exercise

main :: IO ()
main = putStrLn . show . doThingsAndStuff . map Just $
  [" hello", " world,", " how", " ", "are you?"]
