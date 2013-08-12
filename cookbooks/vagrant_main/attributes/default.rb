set_unless[:php_pear][:channels] = [
                                    "pear.pdepend.org",
                                    "pear.phpmd.org",
                                    # "pear.phpunit.de",
                                    "components.ez.no",
                                    "zend.googlecode.com/svn"
                                    # "pear.doctrine-project.org"
                              ]

set_unless[:php_pear][:packages] = [
                                     "PHP_CodeSniffer",
                                     "zend/zend",
                                     "--alldeps phpunit/PHPUnit",
                                     "--alldeps phpmd/PHP_PMD",
                                     "--nodeps MDB2_Driver_mssql"
]
