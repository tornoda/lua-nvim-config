local M = {}

local function complete(prompt, opts)
    opts = opts or {}
    local model = opts.model or "deepseek-coder:latest"
    local url = "http://localhost:11434/api/generate"
    local body = vim.fn.json_encode {
        model = model,
        prompt = prompt,
        stream = false,
        options = {
            temperature = opts.temperature or 0.2,
            max_tokens = opts.max_tokens or 128,
        }
    }
    local curl_cmd = {
        "curl", "-s", url,
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", body,
    }
    local result = vim.fn.system(curl_cmd)
    local decoded = vim.fn.json_decode(result)
    if decoded and decoded.response then
        return decoded.response
    else
        return nil
    end
end

M.complete = complete
return M
