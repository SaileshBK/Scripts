import os

# The encoding argument is set to "utf-8" for both the input and output 
# files, which is a widely used and compatible encoding format. 
# This resolves the UnicodeDecodeError 
def create_readme(script_file):
    with open(script_file, "r", encoding="utf-8") as file:
        lines = file.readlines()

    readme_lines = []
    for line in lines:
        if line.startswith("#"):
            readme_lines.append("\n"+ line[1:].strip())

    readme_file = "README.md"
    if os.path.exists(readme_file):
        with open(readme_file, "r", encoding="utf-8") as file:
            existing_lines = file.readlines()
        # readme_lines = existing_lines + readme_lines
    with open(readme_file, "w", encoding="utf-8") as file:
        file.write("".join(existing_lines))
        file.write("\n".join(readme_lines))

    print(f"File updated: {readme_file}")

if __name__ == "__main__":
    script_file = input("Enter file name you want to extract comments from :")
    if not os.path.exists(script_file):
        raise FileNotFoundError(f"Script file not found: {script_file}")

    create_readme(script_file)
