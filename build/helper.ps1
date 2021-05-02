function global:git_merge($branch) {
  # git fetch origin ${branch} --shallow-since=$REPO_DEFAULT_TIME --quiet


  # Unshallow to merge-base
  $LAST_COMMIT = "HEAD"

  while (1) {
    $LAST_COMMIT = git rev-list --max-parents=0 $LAST_COMMIT
    $LAST_TIME = git log $LAST_COMMIT -1 --format="%ci"


    if ($LAST_TIME -Le $REPO_MASTER_TIME) {
      break
    }


    git fetch origin ${branch} --deepen=25 --no-tags --quiet
  }


  git merge origin/${branch} --quiet


  if ($LastExitCode -Ne 0) {
    git diff --diff-filter=U


    throw "${branch}: merge failed"
  }


  echo "`n"
}



#####################################



function global:git_modify($file, $mode) {
  Move-Item -Path ${file} -Destination ${file}___1
  git add ${file} --force
  Move-Item -Path ${file}___1 -Destination ${file}


  git_edit.exe ${file} ${mode}
  git add ${file} --force
}



#####################################



function global:git_resolve($branch, $mode, $file1, `
  $file2, $file3, $file4, $file5, $file6, $file7, $file8, $file9, $file10 `
) {
  git fetch origin ${branch} --shallow-since=$REPO_DEFAULT_TIME --quiet
  git merge origin/${branch} --quiet


  echo $file1
  echo $file2
  echo $file3
  echo $file4
  echo $file5


  # git diff --diff-filter=U
  git_modify ${file1} ${mode}


  if (${file2} -Ne $Null) {
    git_modify ${file2} ${mode}
  }

  if (${file3} -Ne $Null) {
    git_modify ${file3} ${mode}
  }

  if (${file4} -Ne $Null) {
    git_modify ${file4} ${mode}
  }

  if (${file5} -Ne $Null) {
    git_modify ${file5} ${mode}
  }

  if (${file6} -Ne $Null) {
    git_modify ${file6} ${mode}
  }

  if (${file7} -Ne $Null) {
    git_modify ${file7} ${mode}
  }

  if (${file8} -Ne $Null) {
    git_modify ${file8} ${mode}
  }

  if (${file9} -Ne $Null) {
    git_modify ${file9} ${mode}
  }

  if (${file10} -Ne $Null) {
    git_modify ${file10} ${mode}
  }



  git commit -m "resolved" --allow-empty


  if ($LastExitCode -Ne 0) {
    git diff --diff-filter=U

    throw "${branch}: merge failed"
  }


  echo "`n"
}



#####################################



function global:git_cache($branch) {
  git pull origin ${branch} --depth=1 --allow-unrelated-histories --quiet

  if ((Test-Path -Path "${env:APPVEYOR_BUILD_FOLDER}/cache.zip") -Eq $False) {
    return
  }



  # -------------------------------------- #



  echo "Restoring build cache`n`n"


  unzip "-DDqqo" "${env:APPVEYOR_BUILD_FOLDER}/cache.zip"


  echo "`n"
}
