 $insertQry ="INSERT INTO $cgnTable (cgnId, pool, totalAddresses, allocated)
               VALUES(?, ?, ?, ?)";
  $insertQrySth = $dbHandle->prepare($insertQry);

  #BIND PARAM TO QUERY & EXECUTE QUERY
  $insertQrySth->execute($idNum, $isgValues->[0],$isgValues->[1],$isgValues->[2],$isgValues->[3],$isgValues->[4],$isgValues->[5]);