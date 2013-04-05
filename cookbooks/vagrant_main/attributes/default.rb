set_unless[:php_pear][:channels] = [
                                    "pear.pdepend.org",
                                    "pear.phpmd.org",
                                    # "pear.phpunit.de",
                                    "components.ez.no",
                                    # "pear.doctrine-project.org"
                              ]

set_unless[:php_pear][:packages] = [
                                     "PHP_CodeSniffer",
                                     "--alldeps phpunit/PHPUnit",
                                     "--nodeps MDB2_Driver_mssql"
]
