vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

local shared = require("lsp.shared")

local jdtls = require('jdtls')

local root_markers = { 'pom.xml', 'mvnw', '.git', 'build.gradle', 'gradlew' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == "" then
	return
end

local workspace_dir = vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Mason paths
local mason_path = vim.fn.stdpath("data") .. "/mason"
local jdtls_path = mason_path .. "/packages/jdtls"

-- Find the launcher jar
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Config directory (Mac)
local config_dir = jdtls_path .. "/config_mac"

-- Find Lombok jar
local lombok_jar = vim.fn.glob(mason_path .. "/packages/jdtls/lombok.jar")

local config = {
	cmd = {
		'/opt/homebrew/opt/openjdk@21/bin/java', -- Use Java 21 for JDTLS
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xms1g',
		'-Xmx2G',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		-- Lombok support
		'-javaagent:' .. lombok_jar,
		'-jar', launcher_jar,
		'-configuration', config_dir,
		'-data', vim.fn.expand('~/.cache/jdtls/') .. workspace_dir,
	},

	root_dir = root_dir,

	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-21",
						path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
						default = true,
					},
					{
						name = "JavaSE-17",
						path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
					}
				}
			},
			-- Maven-specific settings
			maven = {
				downloadSources = true,
				updateSnapshots = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			format = {
				enabled = true,
			},
			saveActions = {
				organizeImports = false,
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*"
				},
				filteredTypes = {
					"com.sun.*",
				},
			},
			-- Enable annotation processing for Lombok
			compile = {
				nullAnalysis = {
					mode = "automatic",
				},
			},
			-- Import settings
			import = {
				maven = {
					enabled = true,
				},
				gradle = {
					enabled = false,
				},
				exclusions = {
					"**/node_modules/**",
					"**/.metadata/**",
					"**/archetype-resources/**",
					"**/META-INF/maven/**"
				}
			}
		},
		signatureHelp = { enabled = true },
		contentProvider = { preferred = 'fernflower' },
	},

	init_options = {
		bundles = {},
		extendedClientCapabilities = {
			progressReportsSupport = true,
			classFileContentsSupport = true,
			generateToStringPromptSupport = true,
			hashCodeEqualsPromptSupport = true,
			advancedExtractRefactoringSupport = true,
			advancedOrganizeImportsSupport = true,
			generateConstructorsPromptSupport = true,
			generateDelegateMethodsPromptSupport = true,
			moveRefactoringSupport = true,
			overrideMethodsPromptSupport = true,
			inferSelectionSupport = { "extractMethod", "extractVariable", "extractField" },
		},
	},

    capabilities = shared.capabilities,
    on_attach = function (client, bufnr)
		-- pcall(vim.keymap.del, 'n', 'grr', { buffer = 0 })
		-- pcall(vim.keymap.del, 'n', 'gra', { buffer = 0 })
		-- pcall(vim.keymap.del, 'n', 'grn', { buffer = 0 })
		-- pcall(vim.keymap.del, 'n', 'gri', { buffer = 0 })
		-- pcall(vim.keymap.del, 'n', 'grt', { buffer = 0 })
		shared.on_attach(client, bufnr)

	end 
}

jdtls.start_or_attach(config)
