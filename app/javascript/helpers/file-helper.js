export const fileIcon = (type) => {
    const icons = {
        "application/pdf": ["fa-file-pdf", "has-text-danger"],
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document": ["fa-file-word", "has-text-primary"],
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": ["fa-file-excel", "has-text-success"],
        "application/vnd.openxmlformats-officedocument.presentationml.presentation": ["fa-file-powerpoint", "has-text-warning"],
        "image/jpeg": ["fa-file-image", "has-text-info"],
        "image/png": ["fa-file-image", "has-text-info"],
        "image/gif": ["fa-file-image", "has-text-info"],
    };

    const [icon, color] = icons[type] || ["fa-file", ""];

    return `
      <span class="icon is-small ${color}">
        <i class="fas ${icon}"></i>
      </span>
    `;
};