import SwiftUI

struct OnboardingView: View {
    @ObservedObject var model: PetViewModel
    @State private var selectedSpecies: PetSpecies = .cat
    @State private var petName = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.7), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Text("Choose your pet")
                    .font(.largeTitle.bold())

                Text("It will live with you across the app, widgets, and Dynamic Island.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 28)

                HStack(spacing: 14) {
                    ForEach(PetSpecies.allCases, id: \.self) { species in
                        Button {
                            selectedSpecies = species
                        } label: {
                            VStack(spacing: 8) {
                                Text(species.glyph)
                                    .font(.system(size: 54))
                                Text(species.displayName)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                selectedSpecies == species
                                    ? Color.white.opacity(0.18)
                                    : Color.white.opacity(0.08),
                                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(selectedSpecies == species ? Color.white : Color.clear, lineWidth: 2)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                TextField("Name your pet", text: $petName)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .padding(16)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal)

                Button {
                    model.createPet(name: petName, species: selectedSpecies)
                } label: {
                    Text("Bring Pet to Life")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
                .padding(.horizontal)

                Spacer()
            }
            .foregroundStyle(.white)
        }
    }
}
