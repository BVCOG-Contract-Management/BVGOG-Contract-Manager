// Configure your import map in config/importmap.rb. Read more:
// https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'

import { fileIcon } from './helpers/file-helper'

const uuid_mock = (char_count) => {
    let chars = '0123456789abcdef'.split('');
    let uuid = [], rnd = Math.random, r;
    char_count = char_count || 32;
    return function () {
        for (let i = 0; i < char_count; i++) {
            r = 0 | rnd() * 16;
            uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r & 0xf];
        }
        return uuid.join('');
    }().replace(/(.{8})(.{4})(.{4})(.{4})(.{12})/, '$1-$2-$3-$4-$5');
};

// Helpers
function clearNotice() {
    const notice = document.querySelector('.flash-notice');
    if (notice) {
        // First have the toast slide out by removing the 'slid-out' class
        notice.classList.remove('slid-out');
        // Add event listener to the notice's span
        notice.querySelector('span').addEventListener('click', (event) => {
            notice.classList.add('slid-out');
            // Add event listener earlier than the transitionend event listener
            setTimeout(() => {
                notice.remove();
            }, 5000);
        });
        // Animate the notice to fade out if it is not clicked
        setTimeout(() => {
            notice.classList.add('slid-out');
            setTimeout(() => {
                notice.remove();
            }, 5000);
        }, 5000);
    }
}


// On turbo:load
document.addEventListener('turbo:load', () => {
    // Clear notice
    clearNotice();
    // New vendor option selected in contracts
    // Get references to the vendor select field and the new vendor input field
    const vendorSelect = document.querySelector('#vendor_id');
    const newVendorField = document.querySelector('#new_vendor_field');

    // Add an event listener to the vendor select field
    if (vendorSelect) {
        vendorSelect.addEventListener('change', (event) => {
            // If the value of the vendor select field is 'new_vendor'
            if (event.target.value === 'new') {
                // Show the new vendor input field
                newVendorField.classList.remove('is-hidden');
            } else {
                // Hide the new vendor input field
                newVendorField.classList.add('is-hidden');
            }
        });
    }

    // Set cursor blink in search table
    const searchInput = document.querySelector('#search-input');
    if (searchInput) {
        // Check if the search input field is empty
        if (searchInput.value !== '') {
            // Set the cursor blink
            searchInput.focus();
            searchInput.setSelectionRange(
                searchInput.value.length, searchInput.value.length);
        }
    }

    // Contract uploaded documents
    const uploadedContractDocumentsInput =
        document.querySelector('#contract-documents-file-input');
    if (uploadedContractDocumentsInput) {
        // We maintain all the files uploaded, since
        // the input is cleared when the value is changed
        let files = new DataTransfer();
        // Get the hidden document type select field 
        const documentTypeSelect = document.querySelector('#contract_document_type_hidden');
        const uploadedContractDocumentsTable =
            document.querySelector('#uploaded-contract-documents-table');
        // Get tbody element of the table
        const uploadedContractDocumentsTableBody =
            uploadedContractDocumentsTable.querySelector('tbody');
        // For each file that is uploaded, add a new row to the table
        uploadedContractDocumentsInput.addEventListener('change', (event) => {
            // Clear all rows with class 'new-file'
            const newFileRows = uploadedContractDocumentsTableBody.querySelectorAll('.new-file');
            newFileRows.forEach((row) => {
                row.remove();
            });
            // Maintain existing files when input is changed
            // by adding the new files to the existing ones
            for (let i = 0; i < event.target.files.length; i++) {
                files.items.add(event.target.files[i]);
            }
            // Set the files of the input to the existing files
            // plus the new files
            uploadedContractDocumentsInput.files = files.files;
            for (let i = 0; i < files.items.length; i++) {
                const file = files.items[i].getAsFile();
                // Create new document type select field based on the hidden one using a new ID
                const documentTypeSelectNew = documentTypeSelect.cloneNode(true);
                documentTypeSelectNew.id = `contract_document_type_${uuid_mock(8)}`;
                // Remove is-hidden class from the new select field
                documentTypeSelectNew.classList.remove('is-hidden');
                // Change the name of the new select field to match the file name
                documentTypeSelectNew.name = `contract[contract_documents_attributes][${file.name}][document_type]`;

                // Create a new row for the file
                const fileRow = document.createElement('tr');
                // add class 'new-file' to the row
                // so we can remove it when the the file is removed
                fileRow.classList.add('new-file');
                fileRow.innerHTML = `
                    <td>
                        ${fileIcon(file.type)} 
                        <strong>${file.name.length > 30 ? file.name.substring(0, 30) + '...' :
                        file.name}</strong>
                    </td>
                    <td>
                        ${documentTypeSelectNew.outerHTML}
                    <td>
                        <button type="button" class="button is-danger is-small" data-file-name="${file.name} class="${file.name}">
                            <span class="icon is-small">
                                <i class="fas fa-times"></i>
                            </span>
                            <span>Remove</span>
                        </button>
                    </td>
                `;
                uploadedContractDocumentsTableBody.appendChild(fileRow);
                // Create a new event listener for the remove button
                // so we can remove the file from the input and the table
                const button = fileRow.querySelector(`button[type=button]`);
                button.addEventListener('click', (event) => {
                    // Remove the file from the global list of files
                    const filtered = Array.from(files.files)
                        .filter((f) => f.name !== file.name);
                    const fileList = new DataTransfer();
                    filtered.forEach((f) => fileList.items.add(f));
                    // Change the input's files and the global files
                    // so that if the user submits the form, the files
                    // in the input are correct.
                    // If the user adds more files, the global files
                    // will be updated with the new files
                    uploadedContractDocumentsInput.files = fileList.files;
                    files = fileList;
                    // Remove the row from the table
                    fileRow.remove();
                });
            }
        });
    }

    // Vendor review star rating input
    const vendorReviewStars = document.querySelectorAll('.vendor-review-star');
    if (vendorReviewStars) {
        const input = document.querySelector('#vendor_review_rating');
        vendorReviewStars.forEach((star) => {
            star.addEventListener('click', (event) => {
                // Get the value of the star (the id of the star converted to an
                // integer)
                const value = parseInt(event.target.id);
                // Set the value of the hidden input
                input.value = value;
                // Set the color of the stars
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
            // On mouseover, set the color of the stars
            star.addEventListener('mouseover', (event) => {
                const value = parseInt(event.target.id);
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
            // On mouseout, set the color of the stars
            star.addEventListener('mouseout', (event) => {
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= input.value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
        });
    }

    // Modals handler
    const modals = document.querySelectorAll('.modal');
    if (modals) {
        modals.forEach((modal) => {
            // Get the modal close button
            const modalCloseButtons = modal.querySelectorAll('.modal-close-btn');

            const modalId = modal.id;
            // Get the buttons that opens the modal
            const modalOpenButton = document.querySelector(`#${modalId}-open-btn`);

            // Make the button behave like an <a> tag
            // We do this to avoid making an actual <a> tag which causses redirection when we try to
            // open the modal
            // Make cursor a pointer
            modalOpenButton.style.cursor = 'pointer';
            // Make the button look like a link (Blue text and no underline, remove blue text on hover)
            modalOpenButton.classList.add('has-text-link', 'has-text-decoration-none');
            // Add event listener to the button
            modalOpenButton.addEventListener('mouseover', (event) => {
                modalOpenButton.classList.remove('has-text-link');
            });
            modalOpenButton.addEventListener('mouseout', (event) => {
                modalOpenButton.classList.add('has-text-link');
            });

            // Add event listener to the modal open button
            modalOpenButton.addEventListener('click', (event) => {
                modal.classList.add('is-active');
            });
            
            // Get the modal background
            const modalBackground = modal.querySelector('.modal-background');
            // Add event listener to the modal close button
            modalCloseButtons.forEach((button) => {
                button.addEventListener('click', (event) => {
                    modal.classList.remove('is-active');
                });
            });
            // Add event listener to the modal background
            modalBackground.addEventListener('click', (event) => {
                modal.classList.remove('is-active');
            });
        });
    }

    // Add program or entity on admin page
    const addResourceFields = document.querySelectorAll('.add-resource-field');
    if (addResourceFields) {
        addResourceFields.forEach((addResourceField) => {
            const id = addResourceField.id;
            const textInput = addResourceField.querySelector(`input`);
            const button = addResourceField.querySelector(`button`);
            const table = document.querySelector(`#${id}_table`);
            const hiddenInput = document.querySelector(`#${id}_field`);

            console.log(id, textInput, button, table, hiddenInput)
            
            button.addEventListener('click', (event) => {
                event.preventDefault();
                const value = textInput.value;
                if (value) {
                    hiddenInput.value += `${value},`;
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${value}</td>
                        <td>
                            <button type="button" class="button is-danger is-small">
                                <span class="icon is-small">
                                    <i class="fas fa-times"></i>
                                </span>
                                <span>Remove</span>
                            </button>
                        </td>
                    `;
                    table.appendChild(row);
                    textInput.value = '';
                    const removeButton = row.querySelector('button');
                    removeButton.addEventListener('click', (event) => {
                        event.preventDefault();
                        const value = row.querySelector('td').textContent;
                        hiddenInput.value = hiddenInput.value.replace(`${value},`, '');
                        row.remove();
                    });
                }
            });
        });
    }
});